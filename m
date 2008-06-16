Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbYFPJKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbYFPJKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 05:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbYFPJKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 05:10:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:3521 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbYFPJKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 05:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=eOfAy9wHrOajUDR7j9NzZyL1JkH1vn7WJrr8rj9zWknrilBWsKyFmpV1X+uiY5jLni
         6bh/XWx4ZVJ1SBOGTh9lluGBisg5sGXMJ6Lkh7eR2N8nc+N9O8vvhJnxvkEengY9mcc7
         0jmx+6d2oz9NyLk3QcRTKA8B+RZjZS2n951lg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] IDE fixes
Date: Mon, 16 Jun 2008 11:10:42 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200806152149.11267.bzolnier@gmail.com> <alpine.LFD.1.10.0806151630380.2949@woody.linux-foundation.org> <alpine.LFD.1.10.0806151702400.2949@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806151702400.2949@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806161110.44224.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2008, Linus Torvalds wrote:
> 
> On Sun, 15 Jun 2008, Linus Torvalds wrote:
> > 
> > It *looks* like it has all the new objects, but its 
> > objects/info/alternates is corrupt:
> > 
> > 	[torvalds@hera ide-2.6.git]$ cat objects/info/alternates 
> > 	/home/dump/git/linux-2.6.git/.git/objects
> > 
> > and there is no such thing as "/home/dump/git/linux-2.6.git/"
> 
> Ok, I did the pull by just copying the objects to a local repo, and 
> setting the alternates file correctly. So it worked this time, but please 
> double-check your alternates next time,

Thanks, and sorry for troubles.

Bart
