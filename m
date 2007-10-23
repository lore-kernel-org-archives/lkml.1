Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbXJWKGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbXJWKGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXJWKF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:05:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57710
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbXJWKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:05:57 -0400
Date: Tue, 23 Oct 2007 03:06:22 -0700 (PDT)
Message-Id: <20071023.030622.74744677.davem@davemloft.net>
To: jeff@garzik.org
Cc: barkalow@iabervon.org, linas@austin.ibm.com, chunhao.huang@hotmail.com,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
From: David Miller <davem@davemloft.net>
In-Reply-To: <471DC66D.6000909@garzik.org>
References: <Pine.LNX.4.64.0710221700120.32497@iabervon.org>
	<20071022.171318.104036671.davem@davemloft.net>
	<471DC66D.6000909@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Tue, 23 Oct 2007 06:01:17 -0400

> David Miller wrote:
> > My suggestion is:
 ...
> Sounds good to me also.

Ok, it seems I've sort-of self-nominated myself to implement
this so I'll try to work on it tomorrow :-)
