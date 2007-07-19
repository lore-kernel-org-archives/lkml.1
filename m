Return-Path: <linux-kernel-owner+w=401wt.eu-S1765338AbXGSSxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765338AbXGSSxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbXGSSw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:52:57 -0400
Received: from gw.goop.org ([64.81.55.164]:52598 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbXGSSw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:52:57 -0400
Message-ID: <469FB2A2.8040403@goop.org>
Date: Thu, 19 Jul 2007 11:51:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ravikiran G Thirumalai <kiran@scalex86.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] Change softlockup trigger limit using a kernel	parameter
References: <20070716222650.GA5947@localdomain> <20070718160858.75865461.akpm@linux-foundation.org> <20070719054121.GA15074@localdomain> <20070718230907.741ae56c.akpm@linux-foundation.org> <20070719091142.GA28723@elte.hu> <20070719183129.GB20298@localdomain> <20070719184536.GB10940@elte.hu>
In-Reply-To: <20070719184536.GB10940@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> just in case someone sees false positives and wants to turn it off.

Why not make 0=off?

    J
