Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZJYWg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZJYWg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 18:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZJYWg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 18:36:59 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:53703
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754234AbZJYWg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 18:36:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwAAK5v5Ep8qNN0/2dsb2JhbAAI1XaEPwSCXQ
X-IronPort-AV: E=Sophos;i="4.44,621,1249228800"; 
   d="scan'208";a="476292421"
Subject: Re: udev in kernel source?
From: Ben Nizette <bn@niasdigital.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200910251834.06321.Martin@lichtvoll.de>
References: <200910251834.06321.Martin@lichtvoll.de>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 09:37:56 +1100
Message-Id: <1256510276.9801.126.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 18:33 +0100, Martin Steigerwald wrote:

> There should be an easy way to figure out whether kernel and deeply related 
> userspace tools are matching each other.

There are more tools than just udev which fail to work on various kernel
configurations and versions, though granted udev might be one of the
most "deeply related" ones.  Shipping a matching set isn't the kernel's
job, that's the point of formal distributions :-).  Maybe your real beef
is with udev documentation which should give you info regarding what
udev/kernel pairings should work?

	--Ben.

