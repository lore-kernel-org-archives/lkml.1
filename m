Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXCVTLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXCVTLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXCVTLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:11:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35927
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965277AbXCVTLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:11:40 -0400
Date: Thu, 22 Mar 2007 12:11:39 -0700 (PDT)
Message-Id: <20070322.121139.85400399.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: w@1wt.eu, rkuhn@e18.physik.tu-muenchen.de, andi@firstfloor.org,
       dada1@cosmosbay.com, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] tcp: cubic optimization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070321131721.448de522@freekitty>
References: <20070321191537.GA28914@1wt.eu>
	<20070321131532.66e7f0e1@freekitty>
	<20070321131721.448de522@freekitty>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 21 Mar 2007 13:17:21 -0700

> Use willy's work in optimizing cube root by having table for small values.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

Also applied to net-2.6.22, thanks Stephen.
