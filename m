Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbYDBQPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbYDBQPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbYDBQPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:15:39 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:65191 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbYDBQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:15:38 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Richard Frank <richard.frank@oracle.com>
Cc: Shirley Ma <mashirle@us.ibm.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, rds-devel@oss.oracle.com
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's in infiniband.git)
References: <adave31bayd.fsf@cisco.com>
	<1207120932.4593.47.camel@localhost.localdomain>
	<aday77w2s5z.fsf@cisco.com> <47F3BE33.4000204@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Apr 2008 09:15:36 -0700
In-Reply-To: <47F3BE33.4000204@oracle.com> (Richard Frank's message of "Wed,
	02 Apr 2008 12:11:15 -0500")
Message-ID: <adalk3w2pxz.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2008 16:15:37.0168 (UTC) FILETIME=[C956BD00:01C894DC]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What is the work we need to do here - I was thinking RDS should just work ?

Stuff doesn't get merged into the kernel on its own.  If you want RDS
upstream then the first step is to post patches in a form suitable for
reviewing.  Then respond to the review comments.

The files Documentation/SubmittingPatches and to some extent
Documentation/SubmittingDrivers in the kernel source have more info.

 - R.
