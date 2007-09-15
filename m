Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbXIOSiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbXIOSiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXIOSiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:38:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53732 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXIOSiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:38:15 -0400
Date: Sat, 15 Sep 2007 20:38:14 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: 20070914100717.8900b29b.randy.dunlap@oracle.com
cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another
 options and comments
In-Reply-To: <200709152004.11930.strohel@gmail.com>
Message-ID: <Pine.LNX.4.64.0709152037460.24423@fbirervta.pbzchgretzou.qr>
References: <200709152004.11930.strohel@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 15 2007 20:04, Matej Laitl wrote:
>
>This patch changes notation of selected-by-another items by introducing 2 new
>representations for implied options:
>{*} or {M} for options selected by another modularized one, thus builtin or
>module capable,
>-*- or -M- for options that cannot be at the moment changed by user.

This gets rid of the ambiguous ---, does not it? (If so, nice!)

