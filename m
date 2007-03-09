Return-Path: <linux-kernel-owner+w=401wt.eu-S1767631AbXCIXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767631AbXCIXMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767627AbXCIXMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:12:17 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:1179 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767582AbXCIXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:12:15 -0500
X-IronPort-AV: i="4.14,268,1170662400"; 
   d="scan'208"; a="399478129:sNHT61891568"
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
X-Message-Flag: Warning: May contain useful information
References: <1173419792.32234.131.camel@localhost.localdomain>
	<1173481052.32234.137.camel@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 09 Mar 2007 15:12:13 -0800
In-Reply-To: <1173481052.32234.137.camel@localhost.localdomain> (Rusty Russell's message of "Sat, 10 Mar 2007 09:57:32 +1100")
Message-ID: <ada3b4evwoi.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2007 23:12:13.0497 (UTC) FILETIME=[5F355A90:01C762A0]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps this patch can go into Wesnoth for testing for a while before
we merge it into the kernel?
