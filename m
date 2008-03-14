Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYCNN7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYCNN7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYCNN7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:59:25 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:47558 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYCNN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:59:25 -0400
Message-ID: <47DA84B7.1000409@hp.com>
Date: Fri, 14 Mar 2008 09:59:19 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Stacking bio support
References: <200803110352.41479.phillips@phunq.net>
In-Reply-To: <200803110352.41479.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel - 

I was able to get the first 3 patches ported to the stable tree of 2.6.23, but there were compilation errors - fixed in the 4th patch in the stream I'll post next. Regardless of that, it still failed to boot on a 2-way AMD64. Do you have a set of these patches that builds correctly & boots! :-)

There are checkpatch.pl notices about your patches as well. In any event, like I said above, I'll post the 4 patches that get it to at least build properly. 

Alan
