Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYCYT0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYCYT0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbYCYTZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:25:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41499 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756869AbYCYTZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:25:58 -0400
Message-Id: <20080325192524.343385569@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Mar 2008 14:25:24 -0500
From: dcn@sgi.com
To: jes@sgi.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [Patch 0/5] prepare XPC and XPNET to support SGI UV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of five patches moves XPC and XPNET to drivers/misc/xp in preparation
for enabling X86_64 support.
