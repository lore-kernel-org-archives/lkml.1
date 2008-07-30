Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYG3QcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYG3QcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYG3QcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:32:08 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50235 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYG3QcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:32:06 -0400
X-IronPort-AV: E=Sophos;i="4.31,279,1215388800"; 
   d="scan'208";a="133571699"
From: Roland Dreier <rdreier@cisco.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>,
       Ralph Campbell <ralph.campbell@qlogic.com>,
       Julia Lawall <julia@diku.dk>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/ipath: use unsigned long for irqflags
References: <20080729114030.GA26181@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 30 Jul 2008 09:30:28 -0700
In-Reply-To: <20080729114030.GA26181@localhost.localdomain> (Vegard Nossum's
	message of "Tue, 29 Jul 2008 13:40:30 +0200")
Message-ID: <ada4p671gij.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2008 16:30:30.0898 (UTC) FILETIME=[95335D20:01C8F261]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yikes... thanks, applied for 2.6.27
