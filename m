Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbXHJVeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbXHJVeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXHJVdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:33:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34601 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXHJVdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:33:51 -0400
Date: Fri, 10 Aug 2007 23:33:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mark Cannon <random.bits@rogers.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
In-Reply-To: <200708101724.26724.random.bits@rogers.com>
Message-ID: <Pine.LNX.4.64.0708102332580.3054@fbirervta.pbzchgretzou.qr>
References: <200708101724.26724.random.bits@rogers.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 10 2007 17:24, Mark Cannon wrote:
>
>You pass the kernel the root option to specify the root partition.
>Is there a way to identify a directory in that partition that holds the
>root or something equivalent to this?

No, but you can use pivot_root.



	Jan
-- 
