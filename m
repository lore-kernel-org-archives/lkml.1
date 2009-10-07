Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZJGKm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZJGKm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbZJGKm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:42:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45427
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758845AbZJGKm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:42:26 -0400
Date: Wed, 07 Oct 2009 03:42:22 -0700 (PDT)
Message-Id: <20091007.034222.157492766.davem@davemloft.net>
To: thomas@wytron.com.tw
Cc: netdev@vger.kernel.org, thierry.reding@avionic-design.de,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethoc: limit the number of buffers to 128
From: David Miller <davem@davemloft.net>
In-Reply-To: <1254835525-2529-1-git-send-email-thomas@wytron.com.tw>
References: <1254835525-2529-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Chou <thomas@wytron.com.tw>
Date: Tue,  6 Oct 2009 21:25:25 +0800

> Only 128 buffer descriptors are supported in the core. Limit the
> number in case we have more memory.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

Applied.
