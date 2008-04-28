Return-Path: <linux-kernel-owner+w=401wt.eu-S968280AbYD1XIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968280AbYD1XIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967384AbYD1Wrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:47:33 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:29397 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967357AbYD1Wra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:47:30 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, divy@chelsio.com
Subject: Re: [ofa-general] [PATCH 2.6.26 1/3] RDMA/cxgb3: Correctly serialize peer abort path.
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>
	<20080427160006.31018.66715.stgit@dell3.ogc.int>
	<adaprs9zjjy.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 28 Apr 2008 15:47:27 -0700
In-Reply-To: <adaprs9zjjy.fsf@cisco.com> (Roland Dreier's message of "Mon, 28
	Apr 2008 15:44:17 -0700")
Message-ID: <adahcdlzjeo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2008 22:47:27.0979 (UTC) FILETIME=[D59D4BB0:01C8A981]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oh yeah, and I deleted an unused "out" label
