Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZBUTd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZBUTd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZBUTdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:33:19 -0500
Received: from mga06.intel.com ([134.134.136.21]:59845 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753783AbZBUTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:33:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,246,1233561600"; 
   d="scan'208";a="388706132"
Message-ID: <49A056D5.5090909@linux.intel.com>
Date: Sat, 21 Feb 2009 11:32:37 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH 0/9] PM: Fixes related to suspend and hibernation for
 2.6.29
References: <200902140157.40869.rjw@sisk.pl> <alpine.LFD.2.00.0902202337040.19156@localhost.localdomain> <200902211038.42169.rjw@sisk.pl> <20090221182902.GB12472@suse.de>
In-Reply-To: <20090221182902.GB12472@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I was not planning to send them for .29, sorry I got confused.  I'll
> drop them from my tree and Len can send them all to Linus now.
> 

they really really need to go into .29, they are a fix for a regression.

This patch exists for 6 weeks now as a fix for the regression.. why is it so
hard to get it sent to Linus???

