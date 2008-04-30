Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYD3Faw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYD3Faw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 01:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYD3Fal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 01:30:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57382
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbYD3Fal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 01:30:41 -0400
Date: Tue, 29 Apr 2008 22:30:40 -0700 (PDT)
Message-Id: <20080429.223040.75759909.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
       torvalds@linux-foundation.org, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: [2.6 patch] iwlwifi: move the selects to the tristate drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080428234548.GB3075@tuxdriver.com>
References: <20080428142129.GA5679@beyonder.ift.unesp.br>
	<20080428205849.GB2813@cs181133002.pp.htv.fi>
	<20080428234548.GB3075@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 28 Apr 2008 19:45:48 -0400

> Dave, are you going to snarf this one too?  If not (and presuming no
> one points out yet another problem) I'll just include it in the next
> round of fix patches, probably on tomorrow.

I pulled in Adrian's patch.
