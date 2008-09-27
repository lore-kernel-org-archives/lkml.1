Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYI0QRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYI0QRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYI0QRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:17:34 -0400
Received: from gw.goop.org ([64.81.55.164]:33614 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYI0QRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:17:33 -0400
Message-ID: <48DE5C9A.7020301@goop.org>
Date: Sat, 27 Sep 2008 09:17:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Suresh Siddha <suresh.b.siddha@intel.com>, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ioremap sanity check to catch mapping requests exceeding
 the BAR sizes
References: <20080926014334.GF15609@linux-os.sc.intel.com>	<48DDDDDE.7060707@goop.org> <20080927122145.49ad0cf4@lxorguk.ukuu.org.uk> <48DE46AB.8070505@goop.org> <48DE4C92.3020806@linux.intel.com>
In-Reply-To: <48DE4C92.3020806@linux.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>
>> Yeah, that's fine.  I mean using ioremap on system memory is a bug.
>>
>
> ioremap() already warns on that in a separate check. 

OK, good.

    J

