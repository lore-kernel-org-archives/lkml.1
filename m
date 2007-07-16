Return-Path: <linux-kernel-owner+w=401wt.eu-S1763757AbXGPVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763757AbXGPVer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbXGPVei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:34:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761208AbXGPVeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:34:37 -0400
Message-ID: <469BE462.9030004@redhat.com>
Date: Mon, 16 Jul 2007 17:34:26 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>
Subject: Re: [patch] CFS scheduler, -v19
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com>
In-Reply-To: <4697EC49.4070303@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2007 05:19 PM, Bill Davidsen wrote:
> 
> I should really go back to 2.6.21.6, 2.6.22 has many bizarre behaviors
> with FC6. Automount starts taking 30% of CPU (unused at the moment)

Can you confirm whether CFS is involved, i.e. does it spin like that
even without the CFS patch applied?

