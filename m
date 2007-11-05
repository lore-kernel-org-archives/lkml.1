Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXKEBSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXKEBSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 20:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXKEBSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 20:18:41 -0500
Received: from aun.it.uu.se ([130.238.12.36]:56067 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbXKEBSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 20:18:40 -0500
Date: Mon, 5 Nov 2007 02:18:35 +0100 (MET)
Message-Id: <200711050118.lA51IZHt016079@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, mikpe@it.uu.se
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2007 15:51:43 -0800, H. Peter Anvin wrote:
> Mikael, can you try this patch (rev 3) on your 486?

It works fine.

/Mikael
