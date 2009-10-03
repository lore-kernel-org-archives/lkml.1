Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZJCApK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZJCApK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 20:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZJCApJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 20:45:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:37554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbZJCApI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 20:45:08 -0400
Message-ID: <4AC69E3F.80301@kernel.org>
Date: Sat, 03 Oct 2009 09:43:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Pavel Machek <pavel@ucw.cz>, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 01/19] freezer: don't get over-anxious while waiting
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <4AC658C2.6070406@librato.com> <20091002210445.GE4189@count0.beaverton.ibm.com> <200910022321.11796.rjw@sisk.pl>
In-Reply-To: <200910022321.11796.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 03 Oct 2009 00:43:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

Rafael J. Wysocki wrote:
> Tejun, do you want me to take the patch or is it more convenient to you to
> push it yourself?

Please take the patch.  As long as it's in a stable git tree, it
should be fine for me.

> Also, care to respond to my previous comment?

About the comment?  Dropping it is fine.  Do you want me to resend the
patch w/o the comment?

Thanks.

-- 
tejun
