Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXC3XXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXC3XXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXC3XW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:22:59 -0400
Received: from vscan03.westnet.com.au ([203.10.1.142]:37213 "EHLO
	vscan03.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbXC3XW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:22:59 -0400
X-Greylist: delayed 1707 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 19:22:59 EDT
From: Grant Coady <grant_lkml@dodo.com.au>
To: Oliver Joa <oliver@j-o-a.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel DP965LT Mainboard running?
Date: Sat, 31 Mar 2007 08:54:28 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <195r03lcafge17t48hpm09g2jhpn1uuus9@4ax.com>
References: <460D8FCA.2050907@j-o-a.de>
In-Reply-To: <460D8FCA.2050907@j-o-a.de>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 00:31:38 +0200, Oliver Joa <oliver@j-o-a.de> wrote:

>Hi,
>
>does anyone have a running Intel DP965LT Mainboard? I can not get this 
>Board running. You can see the Problems in the Thread "Corrupt 
>XFS-Filesystems on new Hardware and Kernel". Please can you give me a 
>running Kernel-Config?

http://bugsplatter.mine.nu/system/dp965lt.html  some notes and gotchas
http://bugsplatter.mine.nu/test/boxen/silly/    configs and dmesgs

I've only had reiserfs and ext3 going, not XFS.  

Grant.
