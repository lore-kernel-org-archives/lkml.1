Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYI2Oj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYI2Oj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 10:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYI2OjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 10:39:20 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51622 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbYI2OjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 10:39:20 -0400
Date: Mon, 29 Sep 2008 18:45:30 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Krishna Kumar <krkumar2@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REV2: PATCH 2/2]: workqueue: Modify some users to use the new API
Message-ID: <20080929144530.GC85@tv-sign.ru>
References: <20080929070302.7386.72726.sendpatchset@localhost.localdomain> <20080929070328.7386.70911.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929070328.7386.70911.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Krishna Kumar wrote:
>
> Modify some users to use the new API.

Looks good, but I don't understand this code.

Krishna, I'd suggest you to send each change in a separate patch with
the maintainer cc'ed.

And please don't forget to mention that update() != cancel() + queue().
Otherwise maintainer can miss this fact.

Oleg.

