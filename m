Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbXEVEDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbXEVEDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXEVEDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:03:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56841 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbXEVEDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:03:24 -0400
X-IronPort-AV: i="4.14,564,1170662400"; 
   d="scan'208"; a="152465660:sNHT39703536"
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Status of squashfs?
X-Message-Flag: Warning: May contain useful information
References: <200705212352.17449.rob@landley.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 21 May 2007 21:03:22 -0700
In-Reply-To: <200705212352.17449.rob@landley.net> (Rob Landley's message of "Mon, 21 May 2007 23:52:15 -0400")
Message-ID: <ada1wh9cxo4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 May 2007 04:03:23.0496 (UTC) FILETIME=[244B6680:01C79C26]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > So Fedora uses squashfs, Ubuntu uses, squashfs, Gentoo uses squashfs...  It 
 > seems like the only place I can get a kernel _without_ squashfs is 
 > kernel.org.
 > 
 > Is there a reason for this?

Has anyone tried to merge it upstream?  Do the squashfs developers
want to merge it?

 - R.
