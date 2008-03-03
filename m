Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYCCQrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYCCQrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYCCQrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:47:39 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53746 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbYCCQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:47:39 -0500
X-Sasl-enc: ITmfSbRvz4oG8LXOdSOSehf/BaNESF2N9c04aGq9RLvz 1204562857
Message-ID: <47CC2C0A.6030105@ladisch.de>
Date: Mon, 03 Mar 2008 17:49:14 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 hpet_unregister()
References: <20080301162323.GB25835@cs181133002.pp.htv.fi>
In-Reply-To: <20080301162323.GB25835@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch #if 0's the unused hpet_unregister().

Acked-by: Clemens Ladisch <clemens@ladisch.de>
