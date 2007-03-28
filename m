Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbXC1JJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbXC1JJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXC1JJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:09:33 -0400
Received: from truxi.wincor-nixdorf.com ([217.115.67.78]:50402 "EHLO
	truxi.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbXC1JJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:09:32 -0400
Subject: Re: [PATCH] Add support for ITE887x serial chipsets
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
To: linux@horizon.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20070327183031.9989.qmail@science.horizon.com>
References: <20070327183031.9989.qmail@science.horizon.com>
Content-Type: text/plain
Organization: Wincor Nixdorf International GmbH
Date: Wed, 28 Mar 2007 11:08:52 +0200
Message-Id: <1175072932.3065.8.camel@wsa115.wincor-nixdorf.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2007 09:09:23.0885 (UTC) FILETIME=[C7382DD0:01C77118]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 14:30 -0400, linux@horizon.com wrote:
> Minor point: the chip part numbers are actually IT887x, not ITE887x.

You are correct. Vendor is ITE, product IT887x (id=8872). What is the
advised naming convention for something like this?

> I STFW for a data sheet, but didn't have immediate luck.  Does anyone know where to find
> documentation?

I can't even find the product on the official ITE site... The sheets I
have come from our BIOS development team. I've uploaded them on our FTP
server. The files will be deleted automatically in a few days.

- <ftp://ftp.wincor-nixdorf.com/outgoing/IT8872_v0.2_07182000.PDF>
- <ftp://ftp.wincor-nixdorf.com/outgoing/IT8874F_V0.1_09202001.PDF>

-- 
Niels de Vos <niels.devos@wincor-nixdorf.com>
Wincor Nixdorf International GmbH

