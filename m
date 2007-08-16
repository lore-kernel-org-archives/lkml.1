Return-Path: <linux-kernel-owner+w=401wt.eu-S934814AbXHPL1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814AbXHPL1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXHPL1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:27:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42837 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbXHPL1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:27:11 -0400
Date: Thu, 16 Aug 2007 13:27:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Anand Jahagirdar <anandjigar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
In-Reply-To: <m3lkcbu3ps.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0708161324370.7114@fbirervta.pbzchgretzou.qr>
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
 <m3lkcbu3ps.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 16 2007 13:19, Krzysztof Halasa wrote:
>
>At least make that configurable - on some systems users are allowed
>50 processes or so and I'm sure admins don't really want to know
>which particular users are currently close to limits.
>
>I don't really find the above useful. Perhaps we should warn when users
>try to write to R/O files or execute root-only commands etc?

At least make that configurable.


	Jan
-- 
