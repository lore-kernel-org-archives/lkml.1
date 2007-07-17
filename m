Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbXGQEhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbXGQEhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXGQEhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:37:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39566 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXGQEhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:37:33 -0400
Date: Tue, 17 Jul 2007 07:37:40 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>, Joachim Fenkes <fenkes@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
Message-ID: <20070717043740.GB8527@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <OF2377E85C.B05BDE94-ONC125731A.006E64A7-C125731A.00714F9E@de.ibm.com>
	<ada1wf7vgfb.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada1wf7vgfb.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I still haven't seen much code using the feature or
> even any anecdotal information about the performance impact.

Here's some anecdotal evidence :)
http://lists.openfabrics.org/pipermail/general/2007-May/035758.html

-- 
MST
