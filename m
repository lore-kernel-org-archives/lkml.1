Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbYEMSxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbYEMSxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYEMSx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:53:29 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:3098 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYEMSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:53:28 -0400
X-IronPort-AV: E=Sophos;i="4.27,480,1204531200"; 
   d="scan'208";a="26725448"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.26] RDMA/cxgb3: Wrap the software sq ptr as needed on flush.
References: <20080509201902.13077.53047.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 13 May 2008 11:53:20 -0700
In-Reply-To: <20080509201902.13077.53047.stgit@dell3.ogc.int> (Steve Wise's
	message of "Fri, 09 May 2008 15:19:02 -0500")
Message-ID: <adave1ijasf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2008 18:53:20.0799 (UTC) FILETIME=[9D09FAF0:01C8B52A]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
