Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYJIAl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYJIAl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbYJIAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:41:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32843
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbYJIAlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:41:15 -0400
Date: Wed, 08 Oct 2008 17:40:50 -0700 (PDT)
Message-Id: <20081008.174050.183370451.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/7 2.6.28] cxgb3 - reset the adapter on fatal error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081009003356.13282.25797.stgit@speedy5>
References: <20081009003356.13282.25797.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 08 Oct 2008 17:33:57 -0700

> when a fatal error occurs, bring ports down, reset the chip,
> and bring ports back up.
> 
> Factorize code used for both EEH and fatal error recovery.
> Fix timer usage when bringing up/resetting sge queue sets.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
