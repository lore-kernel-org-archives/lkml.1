Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbXCYQ11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbXCYQ11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXCYQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:27:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:40981 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXCYQ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:27:26 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
X-Message-Flag: Warning: May contain useful information
References: <adad52xnccs.fsf@cisco.com> <ada8xdlnb6f.fsf@cisco.com>
	<20070325072947.GA10734@elte.hu> <20070325073424.GA14242@elte.hu>
	<20070325080626.GA22223@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 25 Mar 2007 09:27:22 -0700
In-Reply-To: <20070325080626.GA22223@elte.hu> (Ingo Molnar's message of "Sun, 25 Mar 2007 10:06:26 +0200")
Message-ID: <adazm61l251.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2007 16:27:22.0214 (UTC) FILETIME=[7715B860:01C76EFA]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > the 64-bit kernel indeed hangs. Does the patch below fix it for you?

Yes, that boots and seems to work fine.

Thanks.
