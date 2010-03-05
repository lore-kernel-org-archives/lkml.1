Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab0CEJRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:17:11 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:34434 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0CEJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:17:07 -0500
Date: Fri, 5 Mar 2010 10:17:04 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] s390: Cleanup xtime usage in s390 code
Message-ID: <20100305101704.4c01fd57@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1267756595-30385-1-git-send-email-johnstul@us.ibm.com>
References: <1267756595-30385-1-git-send-email-johnstul@us.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Mar 2010 18:36:35 -0800
John Stultz <johnstul@us.ibm.com> wrote:

> This replaces direct xtime usage in the s390 arch with timekeeping accessors,
> so we can further clean up the timekeeping core.
> 
> Uncompiled and untested.

Compiles and works. I'll add it to the git390 tree for the next please pull

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

