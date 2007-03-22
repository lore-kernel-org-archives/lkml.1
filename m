Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbXCVRxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbXCVRxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934158AbXCVRxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:53:37 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4127 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934168AbXCVRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:53:36 -0400
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: skyhover.pi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/ipath: check return value of lookup_one_len
X-Message-Flag: Warning: May contain useful information
References: <e3e94873cfa04ae59dbc.1174515494@eng-12.pathscale.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 22 Mar 2007 10:53:24 -0700
In-Reply-To: <e3e94873cfa04ae59dbc.1174515494@eng-12.pathscale.com> (Bryan O'Sullivan's message of "Wed, 21 Mar 2007 15:18:14 -0700")
Message-ID: <adabqilgo6j.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Mar 2007 17:53:24.0683 (UTC) FILETIME=[FCEAB9B0:01C76CAA]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.
