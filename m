Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYDHNF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYDHNF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYDHNFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:05:16 -0400
Received: from mail.atmel.fr ([81.80.104.162]:50019 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYDHNFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:05:15 -0400
Message-ID: <47FB6D86.3050602@atmel.com>
Date: Tue, 08 Apr 2008 15:05:10 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Stelian Pop <stelian@popies.net>, Andrew Victor <linux@maxim.org.za>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] AT91 UDPHS driver: SAM9RL board and cpu integration.
References: <47FA41C6.2040406@atmel.com>
In-Reply-To: <47FA41C6.2040406@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre :
> Adds support for the USB High Speed Device Port on the 
> AT91SAM9RL system on chip. The AT91SAM9RL uses the same 
> UDPHS IP as the AVR32 and the AT91CAP9 (atmel_usba_udc driver).

Submitted as 4940/1

Regards,
-- 
Nicolas Ferre

