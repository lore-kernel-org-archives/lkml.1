Return-Path: <linux-kernel-owner+w=401wt.eu-S1762246AbZLKCh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246AbZLKCh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762102AbZLKCh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:37:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:56193 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbZLKChY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:37:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,378,1257148800"; 
   d="scan'208";a="577678878"
Subject: Re: mmotm-2009-12-08-17-45 resume slowly
From: Zhu Yi <yi.zhu@intel.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <a8e1da0912101747l7e0e9fcbh8a7007e95e7c8509@mail.gmail.com>
References: <a8e1da0912100127k4dcddd65gfe5ff0b1330fe63b@mail.gmail.com>
	 <a8e1da0912100130i2e654796mf899dd27df869673@mail.gmail.com>
	 <20091210184931.257A.A69D9226@jp.fujitsu.com>
	 <4B217219.6040109@crca.org.au>
	 <a8e1da0912101747l7e0e9fcbh8a7007e95e7c8509@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 10:37:28 +0800
Message-ID: <1260499048.12157.219.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 09:47 +0800, Dave Young wrote:
> I can not reproduce the wireless delay today, maybe related to
> wireless environment? 

Try powering off the AP before resume?

Thanks,
-yi

