Return-Path: <linux-kernel-owner+w=401wt.eu-S1759742AbXJXQ5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbXJXQ5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763508AbXJXQlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:41:35 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:60069 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762415AbXJXQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:41:33 -0400
Subject: Re: [2.6 patch] drivers/bluetooth/btsdio.c: fix double-free
From: Marcel Holtmann <marcel@holtmann.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Vrabel <david.vrabel@csr.com>, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071024162635.GM30533@stusta.de>
References: <20071024162635.GM30533@stusta.de>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 18:39:26 +0200
Message-Id: <1193243966.6184.248.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> This patch fixes a double-free spotted by the Coverity checker.

good catch. Patch has been applied to me tree. Thanks.

Regards

Marcel


