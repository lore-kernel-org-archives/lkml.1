Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZHFUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZHFUJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbZHFUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:09:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56561
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634AbZHFUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:09:53 -0400
Date: Thu, 06 Aug 2009 13:10:03 -0700 (PDT)
Message-Id: <20090806.131003.13979199.davem@davemloft.net>
To: isdn@linux-pingi.de
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -next] isdn: fix netjet build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908060705.33130.isdn@linux-pingi.de>
References: <20090805092635.6e6df57e.randy.dunlap@oracle.com>
	<20090805.120302.204538944.davem@davemloft.net>
	<200908060705.33130.isdn@linux-pingi.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <isdn@linux-pingi.de>
Date: Thu, 6 Aug 2009 07:05:32 +0200

> My original approach was to change the Makefile to enter this directory
> unconditional, but it seems that this part of the patch was lost during 
> development.  I will send a new patch after testing with different configs.

Ok, thanks!
