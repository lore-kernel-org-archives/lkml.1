Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbZFJING@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbZFJING (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbZFJIMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:12:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50058
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757453AbZFJIMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:12:50 -0400
Date: Wed, 10 Jun 2009 01:12:52 -0700 (PDT)
Message-Id: <20090610.011252.246691143.davem@davemloft.net>
To: wg@grandegger.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A2F630F.5020602@grandegger.com>
References: <4A2E603E.3040603@grandegger.com>
	<20090609.173806.193714555.davem@davemloft.net>
	<4A2F630F.5020602@grandegger.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Wed, 10 Jun 2009 09:38:55 +0200

> [PATCH v2] can: sja1000_of_platform: fix build problems with printk format
> 
> According to "Documentation/printk-formats.txt", if the type is
> dependent on a config option for its size, like resource_size_t,
> we should use a format specifier of its largest possible type and
> explicitly cast to it.
> 
> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>

Applied, thank you!
