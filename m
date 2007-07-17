Return-Path: <linux-kernel-owner+w=401wt.eu-S935590AbXGQSIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935590AbXGQSIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759729AbXGQSIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:08:06 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17480 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbXGQSID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:08:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAPOhnEarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,546,1175497200"; 
   d="scan'208"; a="183667915:sNHT30987531"
To: linux-kernel@vger.kernel.org
Cc: general@lists.openfabrics.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 11:07:59 -0700
In-Reply-To: <adahco943ip.fsf@cisco.com> (Roland Dreier's message of "Thu, 12 Jul 2007 16:15:58 -0700")
Message-ID: <adazm1urji8.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 18:07:59.0835 (UTC) FILETIME=[68E112B0:01C7C89D]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >  - Take a look at Sean's local SA caching patches.  I merged
 >    everything else from Sean's tree, but I'm still undecided about
 >    these.  I haven't read them carefully yet, but even aside from that
 >    I don't have a good feeling about whether there's consensus about
 >    this yet.  Any opinions about merging, for or against, would be
 >    appreciated here.

Does anyone other than Sean have an opinion here?  If you want this
feature, if you've tested it, if you don't think it's ready yet,
whatever, please speak up -- I don't feel comfortable making a
decision on my own here (although I will if I have to).
