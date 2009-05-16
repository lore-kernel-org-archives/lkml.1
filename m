Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZEPO43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZEPO43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZEPO4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:56:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:50385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbZEPO4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:56:19 -0400
Subject: Re: [PATCH 0/3] make mapped executable pages the first class
 citizen
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090516090005.916779788@intel.com>
References: <20090516090005.916779788@intel.com>
Content-Type: text/plain
Date: Sat, 16 May 2009 16:56:16 +0200
Message-Id: <1242485776.32543.834.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-16 at 17:00 +0800, Wu Fengguang wrote:
> Andrew,
> 
> This patchset makes mapped executable pages the first class citizen.
> This version has incorparated many valuable comments from people in
> the CC list, and runs OK on my desktop. Let's test it in your -mm?

Seems like a good set to me. Thanks for following this through Wu!

