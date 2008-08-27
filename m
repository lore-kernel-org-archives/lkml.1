Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYH0XCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYH0XCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYH0XCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:02:42 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:50140 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbYH0XCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:02:41 -0400
X-IronPort-AV: E=Sophos;i="4.32,283,1217808000"; 
   d="scan'208";a="97720725"
From: Roland Dreier <rdreier@cisco.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: C language lawyers needed
References: <adaod3ef82e.fsf@cisco.com>
	<20080827220652.GD28946@ZenIV.linux.org.uk>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 27 Aug 2008 16:02:40 -0700
In-Reply-To: <20080827220652.GD28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 27 Aug 2008 23:06:52 +0100")
Message-ID: <adafxoqf4dr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Aug 2008 23:02:40.0456 (UTC) FILETIME=[0179FC80:01C90899]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > There isn't.  It's gcc being buggy and inconsistent.

Thanks, I'll file a gcc bug I guess.

 - R.
