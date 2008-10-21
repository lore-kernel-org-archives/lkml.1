Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYJUVVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYJUVVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJUVU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:20:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52894 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754024AbYJUVU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:20:56 -0400
Date: Tue, 21 Oct 2008 16:20:54 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] sgi-xp: add low-level hardware specific functionality
Message-ID: <20081021212054.GB14386@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds some low-level hardware specific functionality to the
xp/xpc drivers.

To build cleanly this patchset is dependent on the following patches
submitted by Russ Anderson <rja@sgi.com>.

[PATCH] x86: Use consistent names for region size and conherence id on x86 and ia64.
 (see http://marc.info/?l=linux-kernel&m=122461625304772&w=2)

[PATCH 1/3] x86: Add UV watchlist bios call
 (see http://marc.info/?l=linux-kernel&m=122461934110503&w=2)
[PATCH 2/3] x86: Add UV memory protection bios call
 (see http://marc.info/?l=linux-kernel&m=122461934110506&w=2)
[PATCH 3/3] x86: Add UV reserved page bios call
 (see http://marc.info/?l=linux-kernel&m=122461934210509&w=2)

[PATCH] Add UV watchlist support
 (see http://marc.info/?l=linux-ia64&m=122462371418298&w=2)

