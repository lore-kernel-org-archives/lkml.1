Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZLNDs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZLNDs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbZLNDs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:48:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50721
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754443AbZLNDs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:48:26 -0500
Date: Sun, 13 Dec 2009 19:48:28 -0800 (PST)
Message-Id: <20091213.194828.260101393.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, yevgenyp@mellanox.co.il, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlx4_core: return a negative error value
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B23EA51.30504@gmail.com>
References: <4B23EA51.30504@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sat, 12 Dec 2009 20:09:05 +0100

> The return value should be negative.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied.
