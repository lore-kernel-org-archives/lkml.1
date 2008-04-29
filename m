Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYD2EqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYD2EqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYD2EqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:46:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:40832 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYD2EqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:46:06 -0400
Subject: Re: [PATCH 2/3] siimage: add sil_* I/O ops
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200804272148.29131.bzolnier@gmail.com>
References: <200804092051.33163.bzolnier@gmail.com>
	 <480A2926.6050404@ru.mvista.com>  <200804272148.29131.bzolnier@gmail.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 14:45:51 +1000
Message-Id: <1209444351.18023.126.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW. siimage crashes on boot here due to dma_ops being mostly full of
NULL... This is with current linus.

Ben.


