Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYIPRX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYIPRX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYIPRXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:23:48 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:19762 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYIPRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:23:47 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, vigneshbabu@gmail.com,
       richard.genoud@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/infiniband/hw: Drop code after return
References: <Pine.LNX.4.64.0809111432400.9593@pc-004.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 16 Sep 2008 10:23:45 -0700
In-Reply-To: <Pine.LNX.4.64.0809111432400.9593@pc-004.diku.dk> (Julia Lawall's
	message of "Thu, 11 Sep 2008 14:33:01 +0200 (CEST)")
Message-ID: <adafxo0dmxq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Sep 2008 17:23:45.0223 (UTC) FILETIME=[F8FEAD70:01C91820]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
