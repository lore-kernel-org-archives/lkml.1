Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYBTEXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYBTEXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYBTEX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:23:28 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:6577 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYBTEX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:23:27 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: flatif@neteffect.com, gstreiff@neteffect.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix off-by-one
X-Message-Flag: Warning: May contain useful information
References: <20080219225900.GR31955@cs181133002.pp.htv.fi>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 19 Feb 2008 20:23:19 -0800
In-Reply-To: <20080219225900.GR31955@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Wed, 20 Feb 2008 00:59:00 +0200")
Message-ID: <adahcg4fe88.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Feb 2008 04:23:21.0600 (UTC) FILETIME=[539B1000:01C87378]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, this is already upstream as 51af33e8
