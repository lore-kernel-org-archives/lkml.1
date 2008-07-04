Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYGDMuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYGDMuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYGDMuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:50:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56376 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYGDMuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:50:14 -0400
Message-ID: <486E1C83.4060704@garzik.org>
Date: Fri, 04 Jul 2008 08:50:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WAN: convert drivers to use built-in netdev_stats
References: <m3d4ly4ns2.fsf@maximus.localdomain>
In-Reply-To: <m3d4ly4ns2.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> There is no point in using separate net_device_stats structs when
> the one in struct net_device is present. Compiles.
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

applied net-next


