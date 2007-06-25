Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXFYKTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXFYKTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXFYKTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:19:07 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21191 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXFYKTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:19:06 -0400
Message-ID: <467F9696.5040300@msgid.tls.msk.ru>
Date: Mon, 25 Jun 2007 14:19:02 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Salvatore De Paolis <depaolis.salvatore@libero.it>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pivot_root alternative
References: <20070624232734.28829225@debian>	<Pine.LNX.4.64.0706242328520.11964@fbirervta.pbzchgretzou.qr>	<467EE48D.5010204@arndnet.de> <20070625000846.25f9a46f@debian>
In-Reply-To: <20070625000846.25f9a46f@debian>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Salvatore De Paolis wrote:
> 
>> use run-init from klibc?
>  
> Thank you both, i'll take a look at run-init:)

By the way, busybox now includes similar applet,
named switch_root.

/mjt
