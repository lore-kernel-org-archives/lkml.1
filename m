Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZIHBX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZIHBX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 21:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZIHBXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 21:23:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:63405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZIHBXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 21:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,349,1249282800"; 
   d="scan'208";a="491358167"
Subject: Re: [PATCH 3/5] debugfs - Change debugfs directory of IWMC3200.
From: Zhu Yi <yi.zhu@intel.com>
To: "leemgs1@gmail.com" <leemgs1@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1252327073.2153.98.camel@centos51>
References: <1252327073.2153.98.camel@centos51>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 09:23:45 +0800
Message-Id: <1252373025.5650.37.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 20:37 +0800, GeunSik Lim wrote:
> From: GeunSik,Lim <leemgs1@gmail.com>
> Date: Mon, 7 Sep 2009 20:46:13 +0900
> Subject: [PATCH 3/5] Change debugfs directory of IWMC3200.
> 
> Change default debugfs directory that mount for debugging
> IWMC3200(Intel Wireless Multicomm 3200 WiFi driver).
> 
> As we all know, We need change default directory for consistency of
> debugfs by Greg.K.H
> 
> Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

