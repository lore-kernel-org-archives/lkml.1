Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXDKIxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXDKIxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXDKIxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:53:22 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1561 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXDKIxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:53:21 -0400
Date: Wed, 11 Apr 2007 12:27:41 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Alpha update
Message-ID: <20070411122741.A17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes and cleanups, including build fixes for recent toolchains,
various platform-specific fixes and graphics support for non-zero PCI
domains.

Thanks to Jay Estabrook for supplying most of these.

Ivan.
