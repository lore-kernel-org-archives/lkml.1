Return-Path: <linux-kernel-owner+w=401wt.eu-S2992536AbXDTImJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992536AbXDTImJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992621AbXDTImI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:42:08 -0400
Received: from smtp20.orange.fr ([193.252.22.29]:43707 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992536AbXDTImI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:42:08 -0400
X-ME-UUID: 20070420084206110.1B0DC1C00081@mwinf2017.orange.fr
Subject: Re: VMWare Workstation 6 for debugging Linux Kernel (!)
From: Xavier Bestel <xavier.bestel@free.fr>
To: roland <devzero@web.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <03f401c782d4$95c323e0$eeeea8c0@aldipc>
References: <03f401c782d4$95c323e0$eeeea8c0@aldipc>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 10:42:02 +0200
Message-Id: <1177058522.14404.132.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 00:46 +0200, roland wrote:

> We just quietly added an exciting feature to Workstation 6.0. I believe it 
> will make WS6 a great tool for Linux kernel development. You can now debug 
> kernel of Linux VM with gdb running on the Host without changing anything in 
> the Guest VM. No kdb, no recompiling and no need for second machine. All you 
> need is a single line in VM's configuration file.

I think qemu has the exact same feature.

	Xav


