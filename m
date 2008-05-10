Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYEJPx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYEJPx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 11:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYEJPxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 11:53:16 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:14948 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYEJPxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 11:53:15 -0400
X-IronPort-AV: E=Sophos;i="4.27,465,1204531200"; 
   d="scan'208";a="26352875"
From: Roland Dreier <rdreier@cisco.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: David Dillow <dillowda@ornl.gov>, Rick Jones <rick.jones2@hp.com>,
       David Miller <davem@davemloft.net>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
References: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com>
	<20080507.141521.193714938.davem@davemloft.net>
	<482498D5.9060008@krogh.cc>
	<20080509.143229.174354251.davem@davemloft.net>
	<4824C936.9000103@krogh.cc> <4824CE43.8060203@hp.com>
	<4824D4C0.10201@krogh.cc> <1210374525.21330.6.camel@lap75545.ornl.gov>
	<48253F33.3000109@krogh.cc>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 10 May 2008 08:53:14 -0700
In-Reply-To: <48253F33.3000109@krogh.cc> (Jesper Krogh's message of "Sat, 10
	May 2008 08:22:43 +0200")
Message-ID: <adave1mp34l.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 May 2008 15:53:14.0500 (UTC) FILETIME=[F4BE5C40:01C8B2B5]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Ok. It must be x8 then:
 >                 Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 1

Actually that line is showing the supported capabilities... you want the
second line a few down that shows the actual status.

 - R.
