Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYLJXTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYLJXTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYLJXSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:18:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40147
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754554AbYLJXSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:18:54 -0500
Date: Wed, 10 Dec 2008 15:18:55 -0800 (PST)
Message-Id: <20081210.151855.191710508.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] net: Make static
From: David Miller <davem@davemloft.net>
In-Reply-To: <493EEF28.1040007@gmail.com>
References: <493EA286.7080500@gmail.com>
	<493EEF28.1040007@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Tue, 09 Dec 2008 23:20:24 +0100

> Sparse asked whether these could be static.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

net-next-2.6 already had some of these fixed already, so
I kicked those parts out and applied the rest of your
patch.

Thanks!
