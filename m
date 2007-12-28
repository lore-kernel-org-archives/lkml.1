Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXL1XCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXL1XCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 18:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXL1XCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 18:02:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbXL1XCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 18:02:43 -0500
Date: Fri, 28 Dec 2007 15:01:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sascha Warner <prx@cinatas.ath.cx>
Cc: linux-kernel@vger.kernel.org, WU Fengguang <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
Message-Id: <20071228150111.e9451632.akpm@linux-foundation.org>
In-Reply-To: <47742268.8040302@cinatas.ath.cx>
References: <47742268.8040302@cinatas.ath.cx>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 23:08:40 +0100 Sascha Warner <prx@cinatas.ath.cx> wrote:

> Hi,
> 
> I applied your patches to 2.6.24-rc6-mm1, but now I am faced with one
> pdflush often using 100% CPU for a long time. There seem to be some rare
> pauses from its 100% usage, however.
> 
> On ~23 minutes uptime i have ~19 minutes pdflush runtime.
> 
> This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo ~x64_64
> 
> Let me know if you need more info.
> 

(some) cc's restored.  Please, always do reply-to-all.
