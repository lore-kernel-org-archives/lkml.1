Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbYDVTpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbYDVTpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYDVTpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:45:02 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46345 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755079AbYDVTpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:45:00 -0400
Date: Tue, 22 Apr 2008 14:44:59 -0500
From: Dean Nelson <dcn@sgi.com>
To: tony.luck@intel.com
Cc: jes@sgi.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [Patch 0/4] prepare XPC and XPNET to support SGI UV -v4
Message-ID: <20080422194459.GB13086@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of four patches moves XPC and XPNET to drivers/misc/sgi-xp in
preparation for enabling SGI UV X86_64 support.

This version is prompted by reported build problems with certain configs,
and a desire to keep things simple by only moving XPC/XPNET as is and
only addressing Lindent and checkpatch.pl issues (not x86_64 issues) at
this time.
