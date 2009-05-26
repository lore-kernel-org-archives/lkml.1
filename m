Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZEZXK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZEZXK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbZEZXKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:10:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57979
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757900AbZEZXKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:10:46 -0400
Date: Tue, 26 May 2009 16:10:45 -0700 (PDT)
Message-Id: <20090526.161045.146842870.davem@davemloft.net>
To: michael.riepe@googlemail.com
Cc: mb@bu3sch.de, dave@thedillows.org, romieu@fr.zoreil.com,
       rsantos@grupopie.com, m.bueker@berlin.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090526.154340.26952708.davem@davemloft.net>
References: <20090526.151410.109935435.davem@davemloft.net>
	<4A1C6FE9.1050003@googlemail.com>
	<20090526.154340.26952708.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 26 May 2009 15:43:40 -0700 (PDT)

> From: Michael Riepe <michael.riepe@googlemail.com>
> Date: Wed, 27 May 2009 00:40:41 +0200
> 
>> Michael Buesch already provided a patch against 2.6.29.4 that we both
>> tested. I doubt that it will apply to 2.6.27 cleanly, though.
> 
> Please forward a copy to me.

Nevermind, I was tired of waiting and fished it out of
patchwork.
