Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYBYW3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYBYW3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbYBYW3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:29:40 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:46312 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYBYW3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:29:38 -0500
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.25] RDMA/cxgb3: Shift calculation wrong for single sge entries.
X-Message-Flag: Warning: May contain useful information
References: <20080220233148.25301.54457.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 25 Feb 2008 14:29:34 -0800
In-Reply-To: <20080220233148.25301.54457.stgit@dell3.ogc.int> (Steve Wise's message of "Wed, 20 Feb 2008 17:31:48 -0600")
Message-ID: <ada63wczn3l.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Feb 2008 22:29:37.0462 (UTC) FILETIME=[E7831D60:01C877FD]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied, although I assume based on the Signed-off-by line
that you left out a

  From: Bryan Rosenburg <rosnbrg@us.ibm.com>

at the top (to get the authorship in git correctly).

 > RDMA/cxgb3: Shift calculation wrong for single sge entries.

BTW, there's no need to duplicate the subject line in the message
body, but if you are going to do it, please put a "Subject:" before
it.  Otherwise I just have to edit it out by hand to avoid git putting
the subject in twice.

 - R.
