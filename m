Return-Path: <linux-kernel-owner+w=401wt.eu-S1764995AbYBZUKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764995AbYBZUKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763036AbYBZUJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:09:56 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:40912 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150AbYBZUJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:09:54 -0500
To: Pete Wyckoff <pw@osc.edu>
Cc: linux-kernel@vger.kernel.org, Olaf Kirch <olaf.kirch@oracle.com>,
       general@lists.openfabrics.org, linux-scsi@vger.kernel.org
Subject: Re: [ofa-general] [PATCH 2/2] ib fmr pool: flush used clean entries
X-Message-Flag: Warning: May contain useful information
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com>
	<20080226182655.GD7033@osc.edu> <20080226182753.GF7033@osc.edu>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 26 Feb 2008 12:09:52 -0800
In-Reply-To: <20080226182753.GF7033@osc.edu> (Pete Wyckoff's message of "Tue, 26 Feb 2008 13:27:53 -0500")
Message-ID: <adazltnwkbz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Feb 2008 20:09:52.0627 (UTC) FILETIME=[8C2C9430:01C878B3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a really nice approach to me.  Olaf?

 - R.
