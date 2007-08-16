Return-Path: <linux-kernel-owner+w=401wt.eu-S1764198AbXHPRwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764198AbXHPRwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 13:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbXHPRw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 13:52:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123AbXHPRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 13:52:26 -0400
Subject: Re: 2.6.22.2-cfs-v19.1 stops honouring nice 3 after some hours
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Gerdau <mgd@technosis.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200708151823.17623.mgd@technosis.de>
References: <200708151823.17623.mgd@technosis.de>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 19:52:17 +0200
Message-Id: <1187286737.6114.100.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 18:23 +0200, Michael Gerdau wrote:
> Hi Ingo,
> 
> I played a bit with renicing my (mostly) CPU bound jobs and found
> somewhat strange behaviour.
> 
> I'm on 2.6.22.2-cfs-v19.1 -- I can't boot into 2.6.23-rc3 as part of
> my daily work because my NVIDIA driver doesn't yet work with it though
> I could try to do some X-less testing if need be.

Please do try, a lot has changed since v19.1.

FWIW the nv driver lets one do most desktop-ish things without problems,
or so I've been told - just no 3d.

