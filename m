Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZLCUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZLCUr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZLCUr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:47:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54194
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbZLCUr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:47:58 -0500
Date: Thu, 03 Dec 2009 12:48:04 -0800 (PST)
Message-Id: <20091203.124804.168589603.davem@davemloft.net>
To: jeff@garzik.org
Cc: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B17F7E4.9040302@garzik.org>
References: <4B1771CD.3090409@garzik.org>
	<20091203165947.13841802@lxorguk.ukuu.org.uk>
	<4B17F7E4.9040302@garzik.org>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Thu, 03 Dec 2009 12:39:48 -0500

> On 12/03/2009 11:59 AM, Alan Cox wrote:
>>> The merge window is upon us, which by strict rules means that anything
>>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
>>
>> Not quite yet - Linus hasn't said "go"
> 
> He rarely if ever says "go."  The kernel X is released, and people
> send pull requests to Linus for X+1.  He typically merges immediately,
> but does not push out the first set of merges for a few days.

I don't think he even starts pulling until 1 or 2 days later.

I personally never send him a pull request until a day or two in.
