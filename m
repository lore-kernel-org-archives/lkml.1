Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbYIWKdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbYIWKdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 06:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYIWKdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 06:33:41 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:59415 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYIWKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:33:40 -0400
Message-ID: <48D8C5E0.3060400@de.ibm.com>
Date: Tue, 23 Sep 2008 12:33:04 +0200
From: Thomas Klein <osstklei@de.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080421)
MIME-Version: 1.0
To: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com
Subject: Re: [PATCH] [2.6.27] ehea: Fix memory hotplug support
References: <200809171619.46741.hannes.hering@linux.vnet.ibm.com>
In-Reply-To: <200809171619.46741.hannes.hering@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Hering wrote:
> This patch implements the memory notifier to update the busmap instantly
> instead of rebuilding the whole map. This is necessary because
> walk_memory_resource provides different information than required during memory
> hotplug.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>

Jeff, please apply.

Acked-by: Thomas Klein <tklein@de.ibm.com>
