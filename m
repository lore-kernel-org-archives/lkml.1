Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYKFWuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYKFWuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYKFWuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:50:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53614 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYKFWuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:50:07 -0500
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] change CONFIG_NUMA description
From: Andi Kleen <andi@firstfloor.org>
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Thu, 06 Nov 2008 23:50:15 +0100
In-Reply-To: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> (KOSAKI Motohiro's message of "Wed, 5 Nov 2008 02:27:19 +0900 (JST)")
Message-ID: <87iqr0o4ew.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> CONFIG_NUMA description talk about a bit old thing.
> So, following changes are better.
>
> o CONFIG_NUMA is no longer EXPERIMENTAL
> o Opteron is not the only processor of NUMA topology on x86_64 no longer, but also Intel Core7i has it.

Actually it doesn't have it. Core i7 systems are single socket and therefore
not NUMA.


-Andi

-- 
ak@linux.intel.com
