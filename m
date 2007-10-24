Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXJXCq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXJXCq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXJXCqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:46:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38391
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbXJXCqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:46:11 -0400
Date: Tue, 23 Oct 2007 19:46:38 -0700 (PDT)
Message-Id: <20071023.194638.105428071.davem@davemloft.net>
To: jeff@garzik.org
Cc: barkalow@iabervon.org, linas@austin.ibm.com, chunhao.huang@hotmail.com,
       gregkh@suse.de, htejun@gmail.com, brice.goglin@gmail.com,
       david.gaarenstroom@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071023.030622.74744677.davem@davemloft.net>
References: <20071022.171318.104036671.davem@davemloft.net>
	<471DC66D.6000909@garzik.org>
	<20071023.030622.74744677.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 23 Oct 2007 03:06:22 -0700 (PDT)

> Ok, it seems I've sort-of self-nominated myself to implement
> this so I'll try to work on it tomorrow :-)

I have a working implementation, fully tested on a machine
with Tigon3 ethernet chips that have the quirk in question.

Patch set coming up next.
