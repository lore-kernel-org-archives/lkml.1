Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYCIUyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYCIUyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYCIUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:54:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42573 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYCIUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:54:24 -0400
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH] iwch_create_cq off by one error
X-Message-Flag: Warning: May contain useful information
References: <1204158583-22858-1-git-send-email-jon@opengridcomputing.com>
	<47C83798.3090702@opengridcomputing.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 09 Mar 2008 13:54:21 -0700
In-Reply-To: <47C83798.3090702@opengridcomputing.com> (Steve Wise's message of "Fri, 29 Feb 2008 10:49:28 -0600")
Message-ID: <adapru3obya.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 20:54:23.0455 (UTC) FILETIME=[C11196F0:01C88227]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
