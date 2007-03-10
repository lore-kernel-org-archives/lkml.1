Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXCJO2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXCJO2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 09:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbXCJO2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 09:28:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:21342 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455AbXCJO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 09:28:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XWzgtl/HJHOm7ypn3+Dc6o844EYtxnqYCdWMd8Ctaf6D1Tu5KbTOY5skiqTM2ZlcspfKKkWHMN3STsqyEDGR+I8YcPbx2e44XmYLyD4uphT4Pd5lMQk3vm/RW0KrZfqvp1Iq/8/wvMuryXq6+gyfXEh1YbFfWs3CI8TPZMxiIT8=
Date: Sat, 10 Mar 2007 17:25:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vladimir <snigga@mail.ru>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070310142522.GA10230@cvg>
References: <20070310160542.21cdb968@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310160542.21cdb968@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Vladimir - Sat, Mar 10, 2007 at 04:05:42PM +0300]
| Here's the problem:
|   1. Unpack the kernel sources, run make menuconfig.
|   2. Mark the necessary options.
|   3. Pick "Save an alternate configuration file", enter a filename (e.g. /root/kernelcfg)
|   4. Pick "Exit".
| ->5. Configurator exits without saving. If type "make bzImage", it builtd all the default options.
| 
| And there's no ".config" file in kernel root directory, so i have to move there my "kernelcfg" and
| rename it.
| 
| If i just run "make menuconfig", then pick "Exit", then it asks "Save kernel configuration?".
| 
| This happens starting from kernel 2.6.20 till 2.6.20.2
| Slackware-current.
| PC: Athlon-XP 2000+, 256 MB RAM.
| Linux wolf 2.6.20.2 #1 SMP PREEMPT Sat Mar 10 15:41:42 MSK 2007 i686 athlon-4 i386 GNU/Linux
| -- 
| Faith manages.

Let us time to review... :)

		Cyrill

