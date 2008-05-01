Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbYEAEcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbYEAEcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYEAEcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:32:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51079 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbYEAEcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:32:18 -0400
Date: Wed, 30 Apr 2008 21:32:14 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 06/10] Introduce ridr_get_new()
Message-ID: <20080501043213.GE30274@tpepper-t42p.dolavim.us>
References: <20080429143304.741001000@bull.net> <20080429143730.504910000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429143730.504910000@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29 Apr at 16:33:10 +0200 Nadia.Derbey@bull.net said:
> [PATCH 06/10]
> 
> This patch introduces the ridr_get_new() routine.

Duplication + small useful cleanup that could be standalone.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
