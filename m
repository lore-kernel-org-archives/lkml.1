Return-Path: <linux-kernel-owner+w=401wt.eu-S965236AbXBFS6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236AbXBFS6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXBFS6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:58:01 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:4644 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965236AbXBFS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:58:00 -0500
X-IronPort-AV: i="4.13,291,1167638400"; 
   d="scan'208"; a="761905077:sNHT44012608"
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org, openib-general@openib.org
Subject: Re: [PATCH 2.6.20] infinband: Use ARRAY_SIZE macro when appropriate
X-Message-Flag: Warning: May contain useful information
References: <20070206160725.GJ8991@Ahmed>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 06 Feb 2007 10:57:55 -0800
In-Reply-To: <20070206160725.GJ8991@Ahmed> (Ahmed S. Darwish's message of "Tue, 6 Feb 2007 18:07:25 +0200")
Message-ID: <ada4ppz866k.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Feb 2007 18:57:55.0265 (UTC) FILETIME=[B5C9AB10:01C74A20]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, queued in my tree for 2.6.21
