Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYAKGZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYAKGZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYAKGY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:24:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46830
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYAKGY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:24:57 -0500
Date: Thu, 10 Jan 2008 22:24:56 -0800 (PST)
Message-Id: <20080110.222456.209443591.davem@davemloft.net>
To: ohad@bencohen.org
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH][FIX] Bluetooth: always send explicit hci_ll wake-up
 acks
From: David Miller <davem@davemloft.net>
In-Reply-To: <tkrat.091a3ceefb96c3e3@bencohen.org>
References: <tkrat.091a3ceefb96c3e3@bencohen.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ohad Ben-Cohen <ohad@bencohen.org>
Date: Mon, 7 Jan 2008 18:22:48 +0200 (IST)

> In the (rare) event of simultaneous mutual wake up requests,
> do send the chip an explicit wake-up ack. This is required
> for Texas Instruments's BRF6350 chip.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>

Applied, thanks.
