Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbZGOSSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbZGOSSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbZGOSSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:18:44 -0400
Received: from gandalf.vpop.net ([216.193.240.4]:61944 "EHLO gandalf.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbZGOSSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:18:42 -0400
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>
Message-Id: <A951B93F-0B11-4276-B271-688F7CC4E06A@vpop.net>
From: Matt Reimer <mreimer@vpop.net>
To: Daniel Mack <daniel@caiaq.de>
In-Reply-To: <1247674841-9909-2-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 2/4] ds2760: export more features
Date: Wed, 15 Jul 2009 11:06:18 -0700
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de> <1247674841-9909-2-git-send-email-daniel@caiaq.de>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 15, 2009, at 9:20 AM, Daniel Mack wrote:

> Export POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW and  
> POWER_SUPPLY_PROP_CAPACITY
> features to the power supply core.
>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>

Acked-by: Matt Reimer <mreimer@vpop.net>

Matt
