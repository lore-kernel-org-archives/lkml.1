Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbZCDIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbZCDIIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZCDII1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:08:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42518
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbZCDII0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:08:26 -0500
Date: Wed, 04 Mar 2009 00:08:11 -0800 (PST)
Message-Id: <20090304.000811.192163997.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] aoe: error printed 1 too early
From: David Miller <davem@davemloft.net>
In-Reply-To: <49A549EE.7020202@gmail.com>
References: <49A549EE.7020202@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Wed, 25 Feb 2009 14:38:54 +0100

> with while (i-- > 0); i reaches -1 after the loop, so the test below is printed
> one too early: 0 still means success.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks.
