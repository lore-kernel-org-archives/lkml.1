Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZC3MYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZC3MYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZC3MYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:24:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59406 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZC3MYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:24:02 -0400
To: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: peak vnodes <number>
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0903300259500.27035@tassadar.physics.auth.gr>
Date: Mon, 30 Mar 2009 14:23:58 +0200
In-Reply-To: <Pine.LNX.4.64.0903300259500.27035@tassadar.physics.auth.gr> (Dimitris Zilaskos's message of "Mon, 30 Mar 2009 03:01:50 +0300 (EEST)")
Message-ID: <87skkvmc69.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitris Zilaskos <dzila@tassadar.physics.auth.gr> writes:

> After moving to 2.6.29 the following started showing up in kernel
> logs. What does it mean?
>
>
> uname -an
> Linux tassadar 2.6.29 #1 Sat Mar 28 22:52:51 EET 2009 i686 unknown
> unknown GNU/Linux
>
>
> dmesg|grep peak|head
> peak vnodes: 4164

Grepping doesn't find such a message in 2.6.29. Are you sure it's not
some out of tree module?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
