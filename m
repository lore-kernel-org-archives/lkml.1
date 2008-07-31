Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYGaLeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYGaLeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYGaLd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:33:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53178
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbYGaLdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:33:55 -0400
Date: Thu, 31 Jul 2008 04:33:55 -0700 (PDT)
Message-Id: <20080731.043355.143045459.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com,
       mpm@selenic.com, jgarzik@pobox.com, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 3/4] Configure out ethtool support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217503770.3454.162.camel@pmac.infradead.org>
References: <1217500967.3454.140.camel@pmac.infradead.org>
	<20080731.035121.177567346.davem@davemloft.net>
	<1217503770.3454.162.camel@pmac.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 31 Jul 2008 12:29:30 +0100

> After an offline discussion, I understand that if we can sort out the
> actual technical issues, you'll carry this in the net tree. Thanks.

I will, but only because you threatened to bypass me and send them
directly to Linus.  And frankly fighting someone willing to do things
like that is simply not worth my time, so I'll just merge them blindly.
You just let me know when you think they are ready for inclusion.
