Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYAKBVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYAKBVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYAKBUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:20:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45524
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbYAKBUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:20:54 -0500
Date: Thu, 10 Jan 2008 17:20:49 -0800 (PST)
Message-Id: <20080110.172049.118174993.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network
 packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <478654C3.60806@nortel.com>
References: <478654C3.60806@nortel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Thu, 10 Jan 2008 11:24:19 -0600

> I've got an issue that's popped up with a deployed system running 
> 2.6.10.
 ...
> So...anyone have any ideas/suggestions?

You have to be kidding, coming here for help with a nearly
4 year old kernel.

The networking stack as well as the e1000 driver has been
practically rewritten several times over since then.
