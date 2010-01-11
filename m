Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348Ab0AKBvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0AKBvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602Ab0AKBvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:51:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:55886 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0AKBvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:51:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,249,1262592000"; 
   d="scan'208";a="763017157"
Subject: Re: [PATCH] iwl-debugfs.c: remove unnecessary casts of void *
From: Zhu Yi <yi.zhu@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <201001081614.10343.hartleys@visionengravers.com>
References: <201001081614.10343.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 09:51:50 +0800
Message-ID: <1263174710.15653.242.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 07:14 +0800, H Hartley Sweeten wrote:
> iwl-debugfs.c: remove unnecessary casts of void *
> 
> void pointers do not need to be cast to other pointer types.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

