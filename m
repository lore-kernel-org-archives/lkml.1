Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372Ab0ANBcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0ANBcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501Ab0ANBcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:32:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57976
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0ANBcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:32:45 -0500
Date: Wed, 13 Jan 2010 17:32:53 -0800 (PST)
Message-Id: <20100113.173253.223656114.davem@davemloft.net>
To: JKosin@intcomgrp.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: at91_ether.c - Allow transmitter interrupt to
 be handled first in ISR
From: David Miller <davem@davemloft.net>
In-Reply-To: <3DBBD805E3BA064A87F551C0E8BD36740289748A@MAILSRV.intcomgrp.com>
References: <3DBBD805E3BA064A87F551C0E8BD36740289748A@MAILSRV.intcomgrp.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Encoding your patches as base64 binary octet stream attachments
causes them to get missed by our automated patch tracking system:

	http://patchwork.ozlabs.org/project/netdev/list/

It works by detecting patches contained in emails posted to the netdev
mailing list.

Can you therefore please follow the guidelines in:

	linux/Documentation/email-clients.txt

for submitting your patches so that they get tracked instead of
lost?

Thanks.
