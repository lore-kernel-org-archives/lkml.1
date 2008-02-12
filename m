Return-Path: <linux-kernel-owner+w=401wt.eu-S1751022AbYBLVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbYBLVZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYBLVZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:25:23 -0500
Received: from baikonur.stro.at ([213.239.196.228]:56800 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYBLVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:25:23 -0500
Date: Tue, 12 Feb 2008 22:24:16 +0100
From: maximilian attems <max@stro.at>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: 464962@bugs.debian.org, Joey Hess <joeyh@debian.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Bug#464962: immediate crash on boot on TM5800
Message-ID: <20080212212416.GH22054@baikonur.stro.at>
References: <20080210031849.GA3370@dragon.kitenet.net> <20080210110659.GB8574@stro.at> <20080210192139.GA17647@kodama.kitenet.net> <20080212160522.GB5221@stro.at> <20080212195254.GA6252@kodama.kitenet.net> <20080212201048.GD22054@baikonur.stro.at> <47B2025B.1030103@zytor.com> <20080212210244.GF22054@baikonur.stro.at> <47B20C1C.5020208@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B20C1C.5020208@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 01:14:04PM -0800, H. Peter Anvin wrote:
> 
> Are you sure that build matches the bug report?

urrgs right sorry, the posted vmlinux is a newer 
2.6.24-git22 and not  Version: 2.6.24-3
 
> The EIP given falls inside the .data segment of that kernel, 
> specifically inside the symbol init_task.
> 
> 	-hpa

will rebuild aboves.
