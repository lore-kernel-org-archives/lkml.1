Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbXJ3UXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbXJ3UXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXJ3UXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:23:07 -0400
Received: from spiffy.freedom.ind.br ([201.35.65.91]:54643 "EHLO
	freedom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753474AbXJ3UXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:23:06 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, balbir@linux.vnet.ibm.com,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
References: <200710122231.50739.elendil@planet.nl>
	<20071029200425.GA830@elte.hu> <20071029214321.GA25669@linux.vnet.ibm.com>
	<200710300019.28871.elendil@planet.nl> <20071029232219.GA12446@elte.hu>
From: Otavio Salvador <otavio@debian.org>
Organization: O.S. Systems Ltda.
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Tue, 30 Oct 2007 18:22:57 -0200
In-Reply-To: <20071029232219.GA12446@elte.hu> (Ingo Molnar's message of "Tue\, 30 Oct 2007 00\:22\:19 +0100")
Message-ID: <87ir4ogxni.fsf@lab.ossystems.com.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Frans Pop <elendil@planet.nl> wrote:
>
>> On Monday 29 October 2007, Balbir Singh wrote:
>> > We'll also need this additional patch (untested),
>> 
>> OK. Both patches together do the trick. Gave it a nice long test run and got 
>> no more weirdness.
>> Tested-by: Frans Pop <elendil@planet.nl>
>
> cool, thanks! I've queued it up for the next scheduler batch.

It would be nice to put those two on stable point release too.

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
