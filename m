Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYFJQYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYFJQYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYFJQYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:24:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54098 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752314AbYFJQYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:24:37 -0400
Date: Tue, 10 Jun 2008 11:24:36 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/3] sgi-xp: response to Andrew's feedback
Message-ID: <20080610162436.GA12985@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a response to comments made by Andrew Morton concerning my
just recently submitted patchset against /drivers/misc/sgi-xp:

    [Patch 00/18] continued prepartion of XPC/XPNET to support SGI UV

It is intended that that this patchset be applied on top of that patchset.

Again, the following is a false positive from scripts/checkpatch.pl.

    WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
    #25: FILE: misc/sgi-xp/xp_sn2.c:25:
    +EXPORT_SYMBOL_GPL(xp_nofault_PIOR);

