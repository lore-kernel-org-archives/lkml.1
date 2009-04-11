Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZDKCgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZDKCgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 22:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZDKCf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 22:35:58 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:18960 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZDKCf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 22:35:57 -0400
Date: Fri, 10 Apr 2009 22:35:35 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
In-reply-to: <200904101439.43480.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.0904102233330.8559@localhost.localdomain>
References: <200904100057.43827.rjw@sisk.pl>
 <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain>
 <200904101439.43480.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastboot also causes the S3 regression here:

http://bugzilla.kernel.org/show_bug.cgi?id=12936

