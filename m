Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYCXCb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYCXCb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 22:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYCXCbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 22:31:17 -0400
Received: from colo.lackof.org ([198.49.126.79]:55277 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbYCXCbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 22:31:16 -0400
Date: Sun, 23 Mar 2008 20:31:02 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: RFC : PATCH for dmfe phy reset needs testing
Message-ID: <20080324023102.GA474@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm got a patch to fix this dmfe driver bug report:
    http://bugzilla.kernel.org/show_bug.cgi?id=2776

But the reporter hasn't responded in ~6 months.
Can someone with dmfe card test the patch for me?

Patch can be pulled from:
    http://iou.parisc-linux.org/~grundler/diff/diff-2.6.23-rc3-dmfe_phy-01

Once it's tested, I'd like to submit and close the bug.

thanks,
gran
