Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbYCZQif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbYCZQif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbYCZQiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:38:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48041 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754883AbYCZQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:38:24 -0400
Date: Wed, 26 Mar 2008 11:38:23 -0500
From: Dean Nelson <dcn@sgi.com>
To: jes@sgi.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [Patch 0/5] prepare XPC and XPNET to support SGI UV -v2
Message-ID: <20080326163823.GA25653@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of five patches moves XPC and XPNET to drivers/misc/xp in preparation
for enabling X86_64 support.
