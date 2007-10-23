Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbXJWVu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbXJWVu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbXJWVui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:50:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37543
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbXJWVuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:50:37 -0400
Date: Tue, 23 Oct 2007 14:51:04 -0700 (PDT)
Message-Id: <20071023.145104.30179908.davem@davemloft.net>
To: auke-jan.h.kok@intel.com
Cc: jeff@garzik.org, ajax@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
From: David Miller <davem@davemloft.net>
In-Reply-To: <471E6121.9010008@intel.com>
References: <471E2AD0.1000500@intel.com>
	<471E5C21.8030908@garzik.org>
	<471E6121.9010008@intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Date: Tue, 23 Oct 2007 14:01:21 -0700

> We help everyone out, and if you merge this patch you will prevent
> users from getting to us for support in the first place.

If using the bad eeprom has to be explicitly enabled by the user, your
argument holds no water.  We just need to make sure the patch does
that.
