Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYJUUA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYJUUA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYJUUAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:00:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50287 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751759AbYJUUAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:00:19 -0400
Date: Tue, 21 Oct 2008 15:00:18 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>
Subject: [PATCH 0/3] x86: More UV bios calls
Message-ID: <20081021200018.GB32545@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three additional UV Runtime Calls.

  [PATCH 1/3] x86: Add UV watchlist bios call
  [PATCH 2/3] x86: Add UV memory protection bios call
  [PATCH 3/3] x86: Add UV reserved page bios call

The bios calls are used by the SGI xp drivers (drivers/misc/sgi-xp).

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
