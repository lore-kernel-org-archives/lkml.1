Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbZLPSGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbZLPSGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762692AbZLPSGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:06:15 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:60309 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762666AbZLPSGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:06:13 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] ep93xx_eth.c: general cleanup
Date: Wed, 16 Dec 2009 13:06:10 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200ED01@mi8nycmail19.Mi8.com>
In-Reply-To: <20091216180132.GL1819@mail.wantstofly.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ep93xx_eth.c: general cleanup
Thread-Index: Acp+edO7ZQFRtm9sSAq1udzncWoe1gAAF+SA
References: <BD79186B4FD85F4B8E60E381CAEE19090200ECE7@mi8nycmail19.Mi8.com> <20091216180132.GL1819@mail.wantstofly.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Lennert Buytenhek" <buytenh@wantstofly.org>
Cc: "kernel list" <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 16 Dec 2009 18:06:10.0347 (UTC) FILETIME=[725FC7B0:01CA7E7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 16, 2009 11:02 AM, Lennert Buytenhek wrote:
> On Wed, Dec 16, 2009 at 12:29:38PM -0500, H Hartley Sweeten wrote:
>
>> General cleanup of the ep93xx_eth driver.
>
> Apart from keeping DRV_MODULE_NAME and DRV_MODULE_VERSION, I have
> no strong opinion about this one way or the other.  So I guess that
> means ACK.

I will add back the DRV_MODULE_NAME and DRV_MODULE_VERSION and repost.

What about the message in ep93xx_eth_init_module()?  Would you prefer
that one to stay?

Regards,
Hartley
