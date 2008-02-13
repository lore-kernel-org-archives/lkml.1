Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbYBMPqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbYBMPqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbYBMPqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:46:31 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:18875 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbYBMPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:46:29 -0500
To: "Diego Guella" <diego.guella@sircomtech.com>
Cc: "Steve Wise" <swise@opengridcomputing.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
Subject: Re: [ofa-general] [PATCH 2.6.25] RDMA/cxgb3: Fail loopbackconnections.
X-Message-Flag: Warning: May contain useful information
References: <20080212220929.24442.76874.stgit@dell3.ogc.int>
	<adafxvxvgz3.fsf@cisco.com> <015c01c86e21$75317210$05c8a8c0@DIEGO>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 13 Feb 2008 07:46:17 -0800
In-Reply-To: <015c01c86e21$75317210$05c8a8c0@DIEGO> (Diego Guella's message of "Wed, 13 Feb 2008 10:18:53 +0100")
Message-ID: <adaskzwuaeu.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Feb 2008 15:46:18.0196 (UTC) FILETIME=[92AB2940:01C86E57]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  > how can a static void function return 0?

good question... I've fixed the patch in my tree.
