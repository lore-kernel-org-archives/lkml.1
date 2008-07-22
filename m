Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYGVXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYGVXh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbYGVXcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:32:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48094 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758310AbYGVXcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:32:23 -0400
Message-ID: <48866DDE.9080201@garzik.org>
Date: Tue, 22 Jul 2008 19:31:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: jie.yang@atheros.com
CC: m.kozlowski@tuxland.pl, bhutchings@solarflare.com, adobriyan@gmail.com,
       yjwei@cn.fujitsu.com, rdreier@cisco.com, shemminger@vyatta.com,
       davem@davemloft.net, jcliburn@gmail.com, parag.warudkar@gmail.com,
       w@1wt.eu, oliver.schuster@schweigstill.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
References: <12163522333496-git-send-email-jie.yang@atheros.com>
In-Reply-To: <12163522333496-git-send-email-jie.yang@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jie.yang@atheros.com wrote:
> From: Jie Yang <jie.yang@atheros.com>
> 
> Full patch for the Atheros L1E Gigabit Ethernet driver.
> Supportring AR8121, AR8113 and AR8114
> 
> Signed-off-by: Jie Yang <jie.yang @atheros.com>
> ---
> update on comments:
> 	1) Remove dup MACRO already defined in linux/ethtool.h
> 	2) Remove pci_using_64 logic for the reason as atl1
> 

applied


