Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXFLNbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXFLNbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXFLNbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:31:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:23057 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbXFLNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:31:17 -0400
Date: Tue, 12 Jun 2007 15:31:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: cannot set IP for ethernet
In-Reply-To: <200706121441.13561.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0706121531040.19578@fbirervta.pbzchgretzou.qr>
References: <200706121441.13561.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12 2007 14:41, Oliver Neukum wrote:
>
>with 2.6.22-rc4-git2 I am getting errors when setting IP for ethernet
>interfaces:
>
>ioctl(4, SIOCSIFADDR, 0x7fff94931600)   = -1 ENOBUFS (No buffer space available)

And if you do it over netlink, as is common today?


	Jan
-- 
