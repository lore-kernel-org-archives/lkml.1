Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbYGQUEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbYGQUEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYGQUEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:04:21 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:43907 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbYGQUEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:04:20 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: jie.yang@atheros.com
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
Date: Thu, 17 Jul 2008 22:04:14 +0200
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, yjwei@cn.fujitsu.com, rdreier@cisco.com,
       shemminger@vyatta.com, davem@davemloft.net, jcliburn@gmail.com,
       parag.warudkar@gmail.com, w@1wt.eu, oliver.schuster@schweigstill.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <12162854952457-git-send-email-jie.yang@atheros.com>
In-Reply-To: <12162854952457-git-send-email-jie.yang@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807172204.15342.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> +#define SPEED_0		   0xffff
> +#define SPEED_10           10
> +#define SPEED_100          100
> +#define SPEED_100          100

Small thing - double define for SPEED_100.

> +#define SPEED_1000         1000

	Mariusz
