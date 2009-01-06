Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZAFWjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZAFWjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbZAFWd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:33:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:20061 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760906AbZAFWd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:33:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rR89smeCuCBnWUZPZI/wFJjiEWnlqZNiLiPs1+CYtFWlReZhnSLwOpqADQLyoIs3Af
         fh+S5btSVQoou1y7mFPOs8+EzCre8OHwtttvcw+umLQ3CvOQPiav0XS/eNXO2ft6APoT
         e1SqZdbhu5qZCcBBYG7m1b7Vn/0c+2vqV8w0k=
Subject: Re: [PATCH 03/23] cris: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>
In-Reply-To: <alpine.LFD.2.00.0901061409270.3057@localhost.localdomain>
References: <1231277446.964.260.camel@brick>
	 <alpine.LFD.2.00.0901061357150.3057@localhost.localdomain>
	 <1231279452.25147.1.camel@brick>
	 <alpine.LFD.2.00.0901061409270.3057@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 14:21:52 -0800
Message-Id: <1231280512.25147.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 14:11 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Jan 2009, Harvey Harrison wrote:
> > 
> > Sure, I sent regular patches as a courtesy to Andrew in case he slurped
> > it up, but I can resend with -M -B if you're going to take it directly,
> > should I wait until I see the remaining 4 arches hit your tree, or will
> > you worry about the timing?
> 
> I'm not sure worrying about the timing makes much sense, since the bigger 
> worry is wanting to merge things in time for -rc1 - and that means having 
> a few days to catch any gotcha's. If parisc/xtensa/cris is broken for a 
> day or two, I don't consider that a problem.


I've seen the sparc pull request go by and will assume it will be in
your tree.

I will not send cris, xtensa, parisc and the removal patches (22-23) so these
arches don't get broken even for a few days and will send those three and the removal
patch as soon as they merged.

Cheers,

Harvey

