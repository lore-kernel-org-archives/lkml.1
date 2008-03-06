Return-Path: <linux-kernel-owner+w=401wt.eu-S934092AbYCFCLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092AbYCFCLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYCFCLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:11:13 -0500
Received: from khc.piap.pl ([195.187.100.11]:33478 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYCFCLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:11:11 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Lattner <clattner@apple.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Michael Matz <matz@suse.de>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
References: <20080305153020.GA24631@volta.aurel32.net>
	<47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com>
	<20080305202319.GA17053@volta.aurel32.net>
	<Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	<20080305204234.GB17267@synopsys.com>
	<20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
	<Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	<20080305212005.GC17267@synopsys.com>
	<84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
	<47CF11D6.7070901@zytor.com>
	<738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
	<47CF1931.2080102@zytor.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 06 Mar 2008 03:11:10 +0100
In-Reply-To: <47CF1931.2080102@zytor.com> (H. Peter Anvin's message of "Wed\, 05 Mar 2008 14\:05\:37 -0800")
Message-ID: <m33ar4bo01.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Not quite, but fixing it in the kernel is easy.
>
> Still breaks for running on all old kernels.

Many more things break on old kernels. I guess it's not worse than
a (local) root exploit, is it?

*-stable and distributions should take care of it, as they do in
others cases.
-- 
Krzysztof Halasa
