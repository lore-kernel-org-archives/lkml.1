Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbXJHSkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbXJHSkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXJHSkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:40:39 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58297 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXJHSki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:40:38 -0400
X-IronPort-AV: E=Sophos;i="4.21,244,1188802800"; 
   d="scan'208";a="232755309"
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
X-Message-Flag: Warning: May contain useful information
References: <25555.1191864285@lwn.net>
	<20071008173706.GA12026@uranus.ravnborg.org>
	<Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 08 Oct 2007 11:40:29 -0700
In-Reply-To: <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Mon, 8 Oct 2007 19:45:27 +0200 (CEST)")
Message-ID: <adave9hjvqa.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Oct 2007 18:40:29.0711 (UTC) FILETIME=[B361C9F0:01C809DA]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > >Reviewed-by:
 > 
 > * I am maintaner or an 'important' person and have had a
 >   look at it in depth

I think anyone should be able to supply a Reviewed-by: tag no matter
who they are.  Of course the weight that such a tag carries in the
final decision of whether or not to merge may depend on who supplied
it, but I don't think we should try to formalize that aspect.

In other words, I would define Reviewed-by: as just "I have looked at
this patch in depth."  Jon's text seems like a really good summation
of that idea in more explicit language.

 - R.
