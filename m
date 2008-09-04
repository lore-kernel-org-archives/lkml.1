Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYIDVsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYIDVsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYIDVsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:48:36 -0400
Received: from suva.vyatta.com ([69.59.150.140]:39264 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbYIDVsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:48:35 -0400
X-Greylist: delayed 2720 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 17:48:35 EDT
Message-Id: <20080904205636.130211023@vyatta.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 13:56:36 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] PCI VPD changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly revised from my last set. Allow mutex to be killed, and
just use yield.

-- 

