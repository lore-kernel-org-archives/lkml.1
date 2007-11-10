Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbXKJPn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbXKJPn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXKJPmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:42:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:51307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbXKJPmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:42:21 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 7/13] Char: nozomi, remove struct irq
Date: Sat, 10 Nov 2007 16:42:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <2694611355132233895.slaby@pripojeni.net>
In-Reply-To: <2694611355132233895.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101642.19215.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:47:31, you (Jiri Slaby) wrote:
> nozomi, remove struct irq
> 
> struct irq (named as my_irq) is used only in ISR and its called functions.
> We might silently use u16 variable on stack and remove all references to
> this structure. This is the first step of struct nozomi_devices removal.

i need a closer look at this (together with RFC 8/13).

Thanks,
Frank
