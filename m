Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbZIKSuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbZIKSuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZIKSuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:50:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54044
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951AbZIKSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:49:59 -0400
Date: Fri, 11 Sep 2009 11:50:15 -0700 (PDT)
Message-Id: <20090911.115015.111772936.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: force bridge module(s) to be GPL
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090910145146.3ee30338@nehalam>
References: <20090910145146.3ee30338@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Thu, 10 Sep 2009 14:51:46 -0700

> The only valid usage for the bridge frame hooks are by a
> GPL components (such as the bridge module).
> The kernel should not leave a crack in the door for proprietary
> networking stacks to slip in.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied, thanks.
