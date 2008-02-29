Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbYB2VdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbYB2VdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934167AbYB2Vco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:32:44 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:23086 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbYB2Vcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:32:43 -0500
X-IronPort-AV: E=Sophos;i="4.25,429,1199692800"; 
   d="scan'208";a="24256058"
To: Pete Wyckoff <pw@osc.edu>
Cc: linux-kernel@vger.kernel.org, Olaf Kirch <olaf.kirch@oracle.com>,
       general@lists.openfabrics.org, linux-scsi@vger.kernel.org
Subject: Re: [ofa-general] [PATCH 2/2] ib fmr pool: flush used clean entries
X-Message-Flag: Warning: May contain useful information
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com>
	<20080226182655.GD7033@osc.edu> <20080226182753.GF7033@osc.edu>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 29 Feb 2008 13:32:33 -0800
In-Reply-To: <20080226182753.GF7033@osc.edu> (Pete Wyckoff's message of "Tue, 26 Feb 2008 13:27:53 -0500")
Message-ID: <ada4pbrv47i.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Feb 2008 21:32:34.0124 (UTC) FILETIME=[98B230C0:01C87B1A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
