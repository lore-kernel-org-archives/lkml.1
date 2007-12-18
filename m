Return-Path: <linux-kernel-owner+w=401wt.eu-S1764978AbXLRARl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764978AbXLRARl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763919AbXLRAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:17:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35669 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763678AbXLRARW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:17:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bernard Pidoux <pidoux@ccr.jussieu.fr>
Cc: Linux Netdev List <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl:  Fix ax25 checks
References: <476303C8.2060507@ccr.jussieu.fr>
	<20071215101810.GA3143@ami.dom.local>
	<476595EC.5050103@ccr.jussieu.fr>
	<m163yxdjrb.fsf_-_@ebiederm.dsl.xmission.com>
	<47670F90.4020004@ccr.jussieu.fr>
Date: Mon, 17 Dec 2007 17:16:43 -0700
In-Reply-To: <47670F90.4020004@ccr.jussieu.fr> (Bernard Pidoux's message of
	"Tue, 18 Dec 2007 01:08:48 +0100")
Message-ID: <m1prx4dfh0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernard Pidoux <pidoux@ccr.jussieu.fr> writes:

> Eric,
>
> I applied your patch and now I have all /proc/sys/net/ax25
> created and initialized as before.

Thanks for reporting this.

Eric
