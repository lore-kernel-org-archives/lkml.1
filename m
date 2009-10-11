Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbZJKX5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbZJKX5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZJKX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:57:43 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:64878 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbZJKX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:57:42 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Mon, 12 Oct 2009 01:57:02 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Rientjes" <rientjes@google.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.d4D.P0l0KB@chimera>
In-Reply-To: <L6tb-VyKHZK.A.d4D.P0l0KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910120157.04616.elendil@planet.nl>
X-OriginalArrivalTime: 11 Oct 2009 23:57:05.0712 (UTC) FILETIME=[89160300:01CA4ACE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, you wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14141
> Subject	: order 2 page allocation failures in iwlagn
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2009-09-06 7:40 (36 days old)
> References	: http://marc.info/?l=linux-kernel&m=125222287419691&w=4
> 		  http://lkml.org/lkml/2009/10/2/86
> 		  http://lkml.org/lkml/2009/10/5/24
> Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>

See: http://lkml.indiana.edu/hypermail/linux/kernel/0910.1/01395.html

I don't see that message on lkml yet :-(
