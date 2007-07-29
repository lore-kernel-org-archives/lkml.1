Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbXG2NvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbXG2NvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763116AbXG2Nuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:50:55 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:20572 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763057AbXG2Nux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:50:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAG43rEarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.19,195,1183359600"; 
   d="scan'208"; a="168621861:sNHT21305034"
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bsg: Fix warning with CONFIG_BLK_DEV_BSG=n
X-Message-Flag: Warning: May contain useful information
References: <ada6443vphh.fsf@cisco.com> <20070729105458.GH32258@kernel.dk>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 29 Jul 2007 06:50:51 -0700
In-Reply-To: <20070729105458.GH32258@kernel.dk> (Jens Axboe's message of "Sun, 29 Jul 2007 12:54:58 +0200")
Message-ID: <adak5sjtj2c.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jul 2007 13:50:52.0278 (UTC) FILETIME=[7A4BB160:01C7D1E7]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > James should already have that patch queued for inclusion since last
 > week.

OK thanks, I missed seeing it go by.
