Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbXD1VFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbXD1VFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030190AbXD1VFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:05:31 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39326 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXD1VF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:05:28 -0400
X-IronPort-AV: i="4.14,465,1170662400"; 
   d="scan'208"; a="416709590:sNHT43379360"
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21-git2] sk_buff changes break Cisco VPN client
X-Message-Flag: Warning: May contain useful information
References: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 28 Apr 2007 14:05:27 -0700
In-Reply-To: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com> (Alessandro Suardi's message of "Sat, 28 Apr 2007 22:38:45 +0200")
Message-ID: <ada647gmcq0.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2007 21:05:27.0398 (UTC) FILETIME=[F2464060:01C789D8]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is really a problem for Cisco support, not the kernel people.
(And despite my email address I really have no idea who looks after
the VPN client).

However I can suggest vpnc (http://www.unix-ag.uni-kl.de/~massar/vpnc/)
as an alternative.  I'm not forced to use Cisco VPN access any more,
but when I tried it, vpnc was tons better than the Cisco product.

 - R.
