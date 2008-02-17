Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYBQXao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYBQXao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYBQXaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:30:35 -0500
Received: from tim.rpsys.net ([194.106.48.114]:51528 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbYBQXae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:30:34 -0500
Subject: Re: [PATCH] leds: disable triggers on brightness set
From: Richard Purdie <rpurdie@rpsys.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47AEE587.6010601@freemail.hu>
References: <1202380503.9519.21.camel@dax.rpnet.com>
	 <20080207213845.GA27862@khazad-dum.debian.net>
	 <1202422388.9519.123.camel@dax.rpnet.com>
	 <20080207232309.GA2041@khazad-dum.debian.net>
	 <47AEE587.6010601@freemail.hu>
Content-Type: text/plain; charset=utf-8
Date: Sun, 17 Feb 2008 23:30:24 +0000
Message-Id: <1203291024.8272.106.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-10 at 12:52 +0100, Németh Márton wrote:
> Disable any active triggers when the brightness attribute is
> set to zero.

I agree with this approach and will merge this as a clarification of the
interface, thanks. I'll also merge your other two patches into the LED
queue.

Cheers,

Richard




