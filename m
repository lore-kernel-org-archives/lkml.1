Return-Path: <linux-kernel-owner+w=401wt.eu-S1161443AbXD1HQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161443AbXD1HQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161468AbXD1HQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:16:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161443AbXD1HQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:16:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use elfnote.h to generate vsyscall notes
In-Reply-To: Jeremy Fitzhardinge's message of  Friday, 27 April 2007 19:21:51 -0700 <4632AFBF.8020602@goop.org>
X-Shopping-List: (1) Tremulous fads
   (2) Sanctimonious hydrants
   (3) Hardy document winters
Message-Id: <20070428071615.242FC1801A4@magilla.sf.frob.com>
Date: Sat, 28 Apr 2007 00:16:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't change the section name that way.  I don't see why the macros
should do differently than what was in vsyscall-note.S to begin with.


Thanks,
Roland

