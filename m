Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXFXV3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXFXV3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXFXV3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:29:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:3636 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXFXV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:29:07 -0400
Date: Sun, 24 Jun 2007 23:29:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Salvatore De Paolis <depaolis.salvatore@libero.it>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pivot_root alternative
In-Reply-To: <20070624232734.28829225@debian>
Message-ID: <Pine.LNX.4.64.0706242328520.11964@fbirervta.pbzchgretzou.qr>
References: <20070624232734.28829225@debian>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 24 2007 23:27, Salvatore De Paolis wrote:
>
>i built the kernel with a busybox initramfs which runs from a usb stick. While
>i boot i need to mount the real root and i'm using pivot_root.
>Pivot_root . old-root return to me an "Invalid argument" error and googling i
>found here http://lkml.org/lkml/2005/10/8/17 that pivot_root should be avoided.
>I want to ask now what i should do to switch to a real root?

use run-init from klibc?


	Jan
-- 
