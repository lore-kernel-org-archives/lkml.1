Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbXJXQzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbXJXQzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763228AbXJXQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:39:22 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:60059 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763222AbXJXQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:39:21 -0400
Subject: Re: [2.6 patch] drivers/bluetooth/bpa10x.c: fix memleak
From: Marcel Holtmann <marcel@holtmann.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071024162632.GL30533@stusta.de>
References: <20071024162632.GL30533@stusta.de>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 18:39:26 +0200
Message-Id: <1193243966.6184.250.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> This patch fixea a memleak spotted by the Coverity checker.

good catch. Patch has been applied to me tree. Thanks.

Regards

Marcel


