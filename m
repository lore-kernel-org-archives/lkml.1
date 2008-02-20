Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbYBTXgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbYBTXgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYBTXg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:36:26 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47195 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763412AbYBTXgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:36:25 -0500
To: "Tony Luck" <tony.luck@gmail.com>
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
X-Message-Flag: Warning: May contain useful information
References: <20080213125725.GC6344@elte.hu>
	<20080213.050340.64342037.davem@davemloft.net>
	<12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
	<20080213.170452.68851396.davem@davemloft.net>
	<12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com>
	<adaprv0rygh.fsf@cisco.com>
	<12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com>
	<ada7ih7qjoq.fsf@cisco.com>
	<1FE6DD409037234FAB833C420AA843EC97C8B0@orsmsx424.amr.corp.intel.com>
	<12c511ca0802141817i3295e83cxd7c05e07f2c54fea@mail.gmail.com>
	<12c511ca0802191440q6a2f5604xe6b563c32c3a90b2@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 20 Feb 2008 15:36:21 -0800
In-Reply-To: <12c511ca0802191440q6a2f5604xe6b563c32c3a90b2@mail.gmail.com> (Tony Luck's message of "Tue, 19 Feb 2008 14:40:35 -0800")
Message-ID: <adatzk3cia2.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Feb 2008 23:36:21.0604 (UTC) FILETIME=[6619F240:01C87419]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, sorry I didn't get a chance to try some of the other debugging
you suggested yet... got busy with other stuff.
