Return-Path: <linux-kernel-owner+w=401wt.eu-S1765010AbYBMAce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765010AbYBMAce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763770AbYBMAcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:32:22 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:35676 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763655AbYBMAcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:32:19 -0500
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCH] infiniband: be*_add_cpu conversion
X-Message-Flag: Warning: May contain useful information
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
	<1202857582-15450-4-git-send-email-marcin.slusarz@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Feb 2008 16:32:16 -0800
In-Reply-To: <1202857582-15450-4-git-send-email-marcin.slusarz@gmail.com> (marcin slusarz's message of "Wed, 13 Feb 2008 00:06:08 +0100")
Message-ID: <adabq6lvgq7.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Feb 2008 00:32:16.0840 (UTC) FILETIME=[E2AC5480:01C86DD7]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

neat.  applied...
