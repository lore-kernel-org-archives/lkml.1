Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYJIAoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYJIAoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYJIAmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:42:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59317
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757546AbYJIAmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:42:43 -0400
Date: Wed, 08 Oct 2008 17:42:19 -0700 (PDT)
Message-Id: <20081008.174219.94348903.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 4/8 2.6.28] cxgb3 - simplify port type struct and usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081009003413.13380.7286.stgit@speedy5>
References: <20081009003413.13380.7286.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 08 Oct 2008 17:34:13 -0700

> Second step in overall phy layer reorganization.
> Clean up the port_type_info structure.
> Support coextistence of clause 22 and clause 45 MDIO devices.
> Select the type of MDIO transaction on a per transaction basis.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
