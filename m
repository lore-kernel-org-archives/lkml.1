Return-Path: <linux-kernel-owner+w=401wt.eu-S1765782AbYBTXWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765782AbYBTXWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYBTXVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:21:54 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:46927 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYBTXVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:21:53 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: flatif@neteffect.com, gstreiff@neteffect.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix off-by-one
X-Message-Flag: Warning: May contain useful information
References: <20080219225900.GR31955@cs181133002.pp.htv.fi>
	<adahcg4fe88.fsf@cisco.com>
	<20080220055744.GC31955@cs181133002.pp.htv.fi>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 20 Feb 2008 15:21:48 -0800
In-Reply-To: <20080220055744.GC31955@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Wed, 20 Feb 2008 07:57:44 +0200")
Message-ID: <adaejb7dxir.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Feb 2008 23:21:48.0979 (UTC) FILETIME=[5DF9F030:01C87417]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > No, 51af33e8 was for a similar same bug 400 lines below this bug...

Heh, sorry.

Glenn -- please review Adrian's patches and let me know which ones are
good to apply.
