Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbXJWVsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbXJWVsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXJWVsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:48:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37538
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXJWVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:48:30 -0400
Date: Tue, 23 Oct 2007 14:48:57 -0700 (PDT)
Message-Id: <20071023.144857.03983847.davem@davemloft.net>
To: jeff@garzik.org
Cc: auke-jan.h.kok@intel.com, ajax@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
From: David Miller <davem@davemloft.net>
In-Reply-To: <471E5C21.8030908@garzik.org>
References: <1193156487.26974.39.camel@localhost.localdomain>
	<471E2AD0.1000500@intel.com>
	<471E5C21.8030908@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Tue, 23 Oct 2007 16:40:01 -0400

> Sorry, I disagree.  Just as with e100, if there is a clear way the user 
> can recover their setup -- and Adam says his was effective -- I don't 
> see why we should be denying users the ability to use their own hardware.

I'd like to second these sentiments.

Just because you can come up with cases where using a wrong
eeprom would fail, does not mean the facility should not be
provided at all.
