Return-Path: <linux-kernel-owner+w=401wt.eu-S1762118AbYCXTGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118AbYCXTGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbYCXTGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:06:23 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:34052 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239AbYCXTGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:06:22 -0400
To: Julia Lawall <julia@diku.dk>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/infiniband: test for IS_ERR rather than 0
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0803241909170.32740@ask.diku.dk>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 24 Mar 2008 12:06:20 -0700
In-Reply-To: <Pine.LNX.4.64.0803241909170.32740@ask.diku.dk> (Julia Lawall's message of "Mon, 24 Mar 2008 19:09:41 +0100 (CET)")
Message-ID: <adawsnsq6vn.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Mar 2008 19:06:21.0279 (UTC) FILETIME=[259646F0:01C88DE2]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neat.  Thanks, applied.
