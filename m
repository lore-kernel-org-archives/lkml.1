Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbXBWVNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbXBWVNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXBWVNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:13:22 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:17804 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXBWVNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:13:20 -0500
X-IronPort-AV: i="4.14,213,1170662400"; 
   d="scan'208"; a="392765213:sNHT39836690"
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       openib-general <openib-general@openib.org>
Subject: Re: [PATCH 2.6.21] iw_cxgb3: Stop the EP Timer on BAD CLOSE.
X-Message-Flag: Warning: May contain useful information
References: <1172090739.27101.39.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 23 Feb 2007 13:13:00 -0800
In-Reply-To: <1172090739.27101.39.camel@stevo-desktop> (Steve Wise's message of "Wed, 21 Feb 2007 14:45:39 -0600")
Message-ID: <adabqjkd1cz.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Feb 2007 21:13:00.0887 (UTC) FILETIME=[66232E70:01C7578F]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, queued for 2.6.21
