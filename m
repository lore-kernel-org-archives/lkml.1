Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZE2GWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZE2GWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZE2GVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:21:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZE2GVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:21:54 -0400
Date: Fri, 29 May 2009 08:28:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [6/16] HWPOISON: Add basic support for poisoned pages in fault handler v2
Message-ID: <20090529062834.GN1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201232.555281D0290@basil.firstfloor.org> <4A1F6166.4020006@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1F6166.4020006@hitachi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this delayacct_clear_flag()? :-p

Hmpf.... Thanks. Fixed. Sorry about this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
