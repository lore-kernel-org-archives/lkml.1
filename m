Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZHKQk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZHKQk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZHKQkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:40:23 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:4901 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZHKQkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:40:20 -0400
X-IronPort-AV: E=Sophos;i="4.43,361,1246838400"; 
   d="scan'208";a="194495072"
From: Roland Dreier <rdreier@cisco.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org
Subject: Re: [PATCH 10/14] infiniband: use printk_once
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	<1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com>
	<adaocqo9sb4.fsf@cisco.com> <4A8045BD.8010803@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 11 Aug 2009 09:40:19 -0700
In-Reply-To: <4A8045BD.8010803@gmail.com> (Marcin Slusarz's message of "Mon,
	10 Aug 2009 18:07:25 +0200")
Message-ID: <adaljlq718s.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Aug 2009 16:40:20.0454 (UTC) FILETIME=[6A563860:01CA1AA2]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
