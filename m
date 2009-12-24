Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbZLXMBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbZLXMBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZLXMBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:01:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:50179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZLXMBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:01:36 -0500
Subject: Re: [PATCH 05/37] kdb: core for kgdb back end
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu, mort@sgi.com,
       linux-arch@vger.kernel.org
In-Reply-To: <4B3356A8.4020901@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
	 <1261652509.4937.185.camel@laptop>  <4B3356A8.4020901@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 13:01:07 +0100
Message-ID: <1261656067.4937.193.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 05:55 -0600, Jason Wessel wrote:
> The remainder was a port from the original kdb, and should not been
> needed.  The preempt_disable and preempt_enable should be able to be
> safely called while the system in the kgdb exception context, so this
> chunk of code is going to get axed and re-tested.

Ok, thanks!

