Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZAFHWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZAFHWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZAFHVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:21:51 -0500
Received: from 1wt.eu ([62.212.114.60]:1113 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbZAFHVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:21:50 -0500
Date: Tue, 6 Jan 2009 08:21:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
Message-ID: <20090106072139.GD5038@1wt.eu>
References: <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu> <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu> <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu> <4962858F.20207@zytor.com> <496285C8.7050503@knaff.lu> <496290E0.3020603@zytor.com> <4963039D.7000804@knaff.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4963039D.7000804@knaff.lu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 08:09:17AM +0100, Alain Knaff wrote:
> H. Peter Anvin wrote:
> > Go ahead and do an incremental patch at this point.
> > 
> >     -hpa
> 
> Thanks, that'll make things easier. Unfortunately, I can no longer check
> out the code. No error messages, but the files just aren't there:
> 
> 
> > git pull
> Already up-to-date.

run "git branch" to see what current branch you're working on.

> > git checkout -b x86/setup-lzma tip/x86/setup-lzma
> git checkout: branch x86/setup-lzma already exists

you should just to "git checkout x86/setup-lzma" since you have already
created that branch (-b XXX YYY creates branch XXX from YYY before doing
the checkout).

normally, if you do the checkout first, then the pull, you should be OK.

Regards,
Willy

