Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYGGXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYGGXBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYGGXBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:01:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55284
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755241AbYGGXBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:01:07 -0400
Date: Mon, 07 Jul 2008 16:01:07 -0700 (PDT)
Message-Id: <20080707.160107.187732466.davem@davemloft.net>
To: jeff@garzik.org
Cc: alan@lxorguk.ukuu.org.uk, mchan@broadcom.com, dwmw2@infradead.org,
       bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <487293F8.30405@garzik.org>
References: <20080707.143803.99767036.davem@davemloft.net>
	<20080707221950.3dfba435@the-village.bc.nu>
	<487293F8.30405@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 07 Jul 2008 18:08:56 -0400

> Alan Cox wrote:
> > And their users and the distributors for whom it can cause enormous pain.
> 
> Where is this enormous pain associated with tg3's compiled-in firmware? 

Indeed.
