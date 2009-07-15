Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbZGOSSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbZGOSSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZGOSSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:18:43 -0400
Received: from gandalf.vpop.net ([216.193.240.4]:52164 "EHLO gandalf.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbZGOSSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:18:42 -0400
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Anton Vorontsov <cbou@mail.ru>
Message-Id: <EE599D8C-0A32-46DC-9C34-34BAE1C2BEE1@vpop.net>
From: Matt Reimer <mreimer@vpop.net>
To: Daniel Mack <daniel@caiaq.de>
In-Reply-To: <1247674841-9909-3-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 3/4] ds2760: add rated_capacity module parameter
Date: Wed, 15 Jul 2009 11:06:07 -0700
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de> <1247674841-9909-2-git-send-email-daniel@caiaq.de> <1247674841-9909-3-git-send-email-daniel@caiaq.de>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 15, 2009, at 9:20 AM, Daniel Mack wrote:

> For systems where the ds2760 is soldered directly on the PCB, the  
> 'rated
> capacity' register is not set to anything useful.
>
> In order to allow users to bootstrap this value, introduce a new  
> module
> parameter 'rated_capacity' and use it to write the internal EEPROM in
> case the value differes from what's been given.
>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>

Acked-by: Matt Reimer <mreimer@vpop.net>

Matt
