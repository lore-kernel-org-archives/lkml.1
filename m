Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXHOKbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXHOKbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXHOKbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:31:01 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56527 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXHOKbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:31:00 -0400
Message-ID: <46C2D4F7.30700@gmail.com>
Date: Wed, 15 Aug 2007 12:27:03 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr> <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr> <46C2CE42.4010303@gmail.com> <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2007 12:20 PM, Jan Engelhardt wrote:

> On Aug 15 2007 11:58, Rene Herman wrote:
>>>>>>> NULL is not 0 though.
>>>>>> It is.  Its representation isn't guaranteed to be all-bits-zero,

>> He said the null _pointer_ isn't guaranteed to be all-bits zero. And it
>> isn't. Read the standard or the faq.
> 
> 0 is all-bits-zero.
> NULL is 0. ("It is.", above)

NULL is a define. It does not have a binary presentation. He was talking 
about the representation of the null pointer, not of 0.

Retarded language lawyering over in comp.lang.c please where all the other 
people who think they just have to be brilliant for having been able to read 
a standards documents go to wank off.

Rene.
