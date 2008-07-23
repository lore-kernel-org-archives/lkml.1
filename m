Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYGWXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYGWXLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYGWXLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:11:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbYGWXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:11:00 -0400
Date: Wed, 23 Jul 2008 16:11:00 -0700 (PDT)
Message-Id: <20080723.161100.219406395.davem@davemloft.net>
To: crmafra2@gmail.com
Cc: tomasw@gmail.com, tytso@mit.edu, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080723225820.GA4099@localhost>
References: <20080723214938.GA8034@mit.edu>
	<1ba2fa240807231502t1c4ce7d5k9b8acbcaed4d166a@mail.gmail.com>
	<20080723225820.GA4099@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Carlos R. Mafra" <crmafra2@gmail.com>
Date: Wed, 23 Jul 2008 17:59:06 -0500

> I am trying to bisect it, but I am facing some difficulties with compilation
> problems and non-booting kernels.

We know what the problem is and are discussing it on netdev
and linux-wireless already.
