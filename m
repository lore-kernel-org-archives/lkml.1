Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbZDKSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbZDKSSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZDKSR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:17:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757426AbZDKSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:17:59 -0400
Date: Sat, 11 Apr 2009 11:11:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Len Brown <lenb@kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
In-Reply-To: <alpine.LFD.2.00.0904102233330.8559@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904111109500.4583@localhost.localdomain>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl> <alpine.LFD.2.00.0904102233330.8559@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, Len Brown wrote:
>
> fastboot also causes the S3 regression here:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12936

Looks like the same issue. Does my one-liner fix that case too?

		Linus
