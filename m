Return-Path: <linux-kernel-owner+w=401wt.eu-S1766717AbXDSOSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766717AbXDSOSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766724AbXDSOSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:18:14 -0400
Received: from bart.ott.istop.com ([66.11.172.99]:37052 "EHLO jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766717AbXDSOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:18:12 -0400
Date: Thu, 19 Apr 2007 10:18:04 -0400
From: Bart Trojanowski <bart@jukie.net>
To: linux-kernel@vger.kernel.org
Subject: how to tell linux (on x86) to ignore 1M or memory
Message-ID: <20070419141804.GO32620@jukie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I need to preserve some state from the bios before entering protected
mode.  For now I want to copy it into some ram accessible by real-mode,
say the last megabyte visible in real-mode.

What's the easiest way to have linux ignore the megabyte starting at 15M?

Cheers,
-Bart
