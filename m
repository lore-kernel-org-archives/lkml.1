Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbYDBQiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbYDBQiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYDBQh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:37:57 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:48290 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbYDBQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:37:57 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Shirley Ma <xma@us.ibm.com>
Cc: Richard Frank <richard.frank@oracle.com>, general@lists.openfabrics.org,
       general-bounces@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       rds-devel@oss.oracle.com
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's	in infiniband.git)
References: <OF1D776305.7E25BAA6-ON8725741F.005B027C-8825741F.002F5161@us.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Apr 2008 09:37:53 -0700
In-Reply-To: <OF1D776305.7E25BAA6-ON8725741F.005B027C-8825741F.002F5161@us.ibm.com>
	(Shirley Ma's message of "Wed, 2 Apr 2008 09:36:12 -0700")
Message-ID: <adar6do1ace.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2008 16:37:56.0125 (UTC) FILETIME=[E76B5CD0:01C894DF]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Can the maintainer submit RDS patch for mainline kernel, in 2.6.26 or
 > 2.6.27 window? It's hard for Distros pick this feature without mainline
 > kernel acceptance.

At least as a first order approximation, there is no chance of RDS being
merged for 2.6.26 even if patches appear right this second...
