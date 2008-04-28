Return-Path: <linux-kernel-owner+w=401wt.eu-S967222AbYD1XK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967222AbYD1XK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967881AbYD1Wyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:54:33 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:15399 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967822AbYD1Wyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:54:31 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, divy@chelsio.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.26 3/3] RDMA/cxgb3: Support peer-2-peer connection setup.
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>
	<20080427160010.31018.67436.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 28 Apr 2008 15:54:29 -0700
In-Reply-To: <20080427160010.31018.67436.stgit@dell3.ogc.int> (Steve Wise's
	message of "Sun, 27 Apr 2008 11:00:10 -0500")
Message-ID: <adad4o9zj2y.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2008 22:54:30.0119 (UTC) FILETIME=[D13ABF70:01C8A982]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks applied (and I see you deleted the unused label in this patch, heh)
