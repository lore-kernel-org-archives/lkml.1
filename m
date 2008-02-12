Return-Path: <linux-kernel-owner+w=401wt.eu-S1765145AbYBLVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765145AbYBLVE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761721AbYBLVET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:04:19 -0500
Received: from baikonur.stro.at ([213.239.196.228]:56077 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbYBLVES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:04:18 -0500
Date: Tue, 12 Feb 2008 22:02:44 +0100
From: maximilian attems <max@stro.at>
To: "H. Peter Anvin" <hpa@zytor.com>, 464962@bugs.debian.org
Cc: Joey Hess <joeyh@debian.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Bug#464962: immediate crash on boot on TM5800
Message-ID: <20080212210244.GF22054@baikonur.stro.at>
References: <20080210031849.GA3370@dragon.kitenet.net> <20080210110659.GB8574@stro.at> <20080210192139.GA17647@kodama.kitenet.net> <20080212160522.GB5221@stro.at> <20080212195254.GA6252@kodama.kitenet.net> <20080212201048.GD22054@baikonur.stro.at> <47B2025B.1030103@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2025B.1030103@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:32:27PM -0800, H. Peter Anvin wrote:
> 
> INT 6 is #UD, undefined instruction.
> 
> If you could send me a copy of your vmlinux file (not bzImage), it would 
> speed things up.

cp -l src/linux-2.6-2.6.24/debian/build/build_i386_none_686/vmlinux ~/public_html/

http://charm.itp.tuwien.ac.at/~mattems/
 
> I happen to have an old TM5800-based machine sitting around, so I can 
> probably reproduce it.
> 
> 	-hpa

cool
