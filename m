Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZGMBUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZGMBUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 21:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZGMBUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 21:20:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47075
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbZGMBUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 21:20:12 -0400
Date: Sun, 12 Jul 2009 18:20:15 -0700 (PDT)
Message-Id: <20090712.182015.156223906.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 3/9] sparc: remove driver-core BUS_ID_SIZE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247438766-17266-3-git-send-email-gregkh@suse.de>
References: <20090712223717.GB16600@kroah.com>
	<1247438766-17266-3-git-send-email-gregkh@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>
Date: Sun, 12 Jul 2009 15:46:00 -0700

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> The name size limit is gone from the driver-core, the BUS_ID_SIZE
> value will be removed.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
