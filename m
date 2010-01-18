Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564Ab0ARN6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab0ARN6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337Ab0ARN6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:58:53 -0500
Received: from dan.rpsys.net ([93.97.175.187]:59381 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0ARN6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:58:53 -0500
Subject: Re: [PATCH] leds: make PCI device id constant
From: Richard Purdie <rpurdie@rpsys.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
In-Reply-To: <4B491B17.5070305@freemail.hu>
References: <4B491B17.5070305@freemail.hu>
Content-Type: text/plain; charset=utf-8
Date: Mon, 18 Jan 2010 13:58:55 +0000
Message-Id: <1263823135.26227.100.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 01:11 +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct pci_driver is constant in <linux/pci.h>
> so it is worth to make pci_device_id also constant.
> 
> The semantic match that finds this kind of pattern is as follows:
> (http://coccinelle.lip6.fr/)

Queued in the LED tree, thanks.

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

