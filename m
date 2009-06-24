Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbZFXEhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbZFXEhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 00:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZFXEg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 00:36:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37120
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbZFXEg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 00:36:57 -0400
Date: Tue, 23 Jun 2009 21:37:01 -0700 (PDT)
Message-Id: <20090623.213701.217032417.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
Subject: Re: [patch 3/6] ide: always kill the whole request on error
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906240249.33505.bzolnier@gmail.com>
References: <200906232327.27610.bzolnier@gmail.com>
	<20090623.161904.177489795.davem@davemloft.net>
	<200906240249.33505.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 24 Jun 2009 02:49:32 +0200

> On Wednesday 24 June 2009 01:19:04 David Miller wrote:
>> I have a hard time believing all of these differences are there for no
>> reason at all. :-)
> 
> Lets keep personal believes aside in the technical discussions. ;)

Sure, but every time I've ignored such possibility I've regretted
it after a long debugging session later, that's all :-)
