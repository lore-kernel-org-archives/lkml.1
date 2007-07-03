Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbXGCFWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbXGCFWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXGCFWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:22:35 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:19223 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbXGCFWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:22:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABN6iUarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,490,1175497200"; 
   d="scan'208"; a="499615364:sNHT407265076"
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Greg KH" <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
X-Message-Flag: Warning: May contain useful information
References: <200706291326.43563.yinghai.lu@sun.com>
	<200707021537.13840.yinghai.lu@sun.com>
	<20070703051336.GF18420@kroah.com>
	<86802c440707022217w40d67b40o9f533a1f93b4807f@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 02 Jul 2007 22:22:17 -0700
In-Reply-To: <86802c440707022217w40d67b40o9f533a1f93b4807f@mail.gmail.com> (Yinghai Lu's message of "Mon, 2 Jul 2007 22:17:56 -0700")
Message-ID: <adafy466oza.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jul 2007 05:22:19.0555 (UTC) FILETIME=[208E2730:01C7BD32]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > [PATCH 4/4] usb: add usb_alloc_urb_node to use use kmalloc_node

If you're fixing things up, change "use use" to "use" while you're at it...
