Return-Path: <linux-kernel-owner+w=401wt.eu-S2992920AbXCIDTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992920AbXCIDTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992923AbXCIDTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:19:41 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:46916 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992920AbXCIDTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:19:40 -0500
X-IronPort-AV: i="4.14,265,1170662400"; 
   d="scan'208"; a="399030358:sNHT42375480"
To: "David Brown" <dmlb2000@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: KVM and rtc missing interupts 2.6.21-rc3
X-Message-Flag: Warning: May contain useful information
References: <9c21eeae0703081348i713c996bked9ebe2af76bc2db@mail.gmail.com>
	<adatzwvxuta.fsf@cisco.com>
	<9c21eeae0703081647u4c203fa8re315e07467c563fe@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 08 Mar 2007 19:19:35 -0800
In-Reply-To: <9c21eeae0703081647u4c203fa8re315e07467c563fe@mail.gmail.com> (David Brown's message of "Thu, 8 Mar 2007 16:47:54 -0800")
Message-ID: <ada7itrxfw8.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2007 03:19:36.0037 (UTC) FILETIME=[C3A37950:01C761F9]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Try running your guest with -no-kvm (and even with the kvm module not
 > > loaded, just to be sure).  In my case I still saw the messages.
 > > However, removing the "-net tap" line from my command line did get rid
 > > of the messages.
 > 
 > Hmmm I'm getting the same thing on 2.6.20.1 as well.

With or without kvm?

 - R.
