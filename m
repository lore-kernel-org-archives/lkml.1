Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZEMFJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZEMFJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbZEMFJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:09:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50795
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbZEMFJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:09:35 -0400
Date: Tue, 12 May 2009 22:09:31 -0700 (PDT)
Message-Id: <20090512.220931.138424766.davem@davemloft.net>
To: Luc.Goria@adept-telecom.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27.2] datagram handling routines :
 mapping/unmapping paged data in soft IRQ
From: David Miller <davem@davemloft.net>
In-Reply-To: <54466B0E862D654998371DCA86B6FE2F4B6DC1@adept-srv2.adept.local>
References: <54466B0E862D654998371DCA86B6FE2F4B6DC1@adept-srv2.adept.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luc Goria" <Luc.Goria@adept-telecom.fr>
Date: Tue, 12 May 2009 10:48:37 +0200

> My company, based in France, develops, manufactures and markets VoIP
> communication platforms.

These interfaces are not designed to be used this way.

And we are also not tied to how your external proprietary
module does things.  And if your code was upstream, we would
fix it to use these interfaces properly.

Therefore I have no reason to look at your patch.

Sorry.
