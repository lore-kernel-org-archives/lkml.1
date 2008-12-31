Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYLaBrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYLaBrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYLaBr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:47:28 -0500
Received: from ethlife-a.ethz.ch ([129.132.49.178]:56158 "HELO ethlife.ethz.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751916AbYLaBr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:47:28 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2008 20:47:27 EST
Message-ID: <495ACD9A.40804@pflanze.mine.nu>
Date: Wed, 31 Dec 2008 02:40:42 +0100
From: Christian Jaeger <christian@pflanze.mine.nu>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: lmage11@twcny.rr.com, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: IRC?
References: <20081229.183402.50984633.davem@davemloft.net> <20081230024651.K102R.401971.root@hrndva-web19-z02> <20081230033552.GE29678@bombadil.infradead.org>
In-Reply-To: <20081230033552.GE29678@bombadil.infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> I believe the kernelnewbies folks already have a well-publicized irc
> location... There are typically at least a few developers there.

I quite like the #kernelnewbies since it's the only place I know where I
can ask userspace questions :~D

I'm mostly a userspace developer, my life writing kernel code is
restricted to a couple of tiny drivers and one-line tweaks. And merging
of thirdparty patches. So I don't have much need for asking questions
about kernelspace questions, but frequently I need to know how I
interface to something in the kernel but don't know how (example: how do
I get at the blocksize and size of a block device? (I know the answer
now.) Or what the name of the "sandboxing" feature of Linux was
(seccomp) and how it seemed to have changed interfaces. Getting clarity
with questions like which tool displays which kind of cpu usage ("what
is iowait?"). Getting help when I see strange behaviour like with I/O
almost locking up the machine. Which are the right git trees to get the
kernel. "Is there a way to change the pipe kernel buffer size from user
space
?" "What is a/the 'TSC'?" How to crosscompile (make ARCH=i386). etc. etc.)

I'm almost always feeling guilty misusing that channel for such
questions, but it's the best place I know where I can get answers to
such questions... :) Thanks for anyone there bearing with me.

Christian.
