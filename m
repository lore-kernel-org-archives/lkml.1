Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbXCSVYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbXCSVYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXCSVYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:24:54 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:8318 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbXCSVYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:24:53 -0400
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12 of 33] IB/ipath - fix bad argument to clear_bit that trashed memory and/or crashed
X-Message-Flag: Warning: May contain useful information
References: <84a9691cf7ff54ce76de.1173995096@iqa-25.internal.keyresearch.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Mar 2007 14:24:50 -0700
In-Reply-To: <84a9691cf7ff54ce76de.1173995096@iqa-25.internal.keyresearch.com> (Bryan O'Sullivan's message of "Thu, 15 Mar 2007 14:44:56 -0700")
Message-ID: <adaircxlye5.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Mar 2007 21:24:50.0461 (UTC) FILETIME=[06FD94D0:01C76A6D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Similarly -- shouldn't an obvious memory corruption fix be in 2.6.21?
