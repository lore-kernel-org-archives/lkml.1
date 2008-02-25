Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbYBYXgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbYBYXgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYBYXg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:36:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33202 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbYBYXg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:36:28 -0500
Message-ID: <47C350FA.7060700@garzik.org>
Date: Mon, 25 Feb 2008 18:36:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Marin Mitov <mitov@issp.bas.bg>
CC: linux-kernel@vger.kernel.org, NetDev <netdev@vger.kernel.org>
Subject: Re: [git patches] net driver updates
References: <OF5F5F5698.07AB615F-ON652573F6.00142D8A-652573F6.00147DC9@in.ibm.com> <8A71B368A89016469F72CD08050AD334026D652F@maui.asicdesigners.com> <47C34838.3040502@garzik.org> <200802260134.02075.mitov@issp.bas.bg>
In-Reply-To: <200802260134.02075.mitov@issp.bas.bg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marin Mitov wrote:
> On Tuesday 26 February 2008 12:59:04 am you wrote:
>> Divy Le Ray wrote:
>>>> From: "Divy Le Ray" <divy@chelsio.com>
>>>> Date: Wed, 20 Feb 2008 21:57:08 -0800
>>>>
>>>>> The driver is cxgb3 here, it uses LLTX.
>>>> That's extremely unfortunate, hopefully you can update it to
>>>> use a model like tg3 and others use.  LLTX is a lost cause
>>>> for hardware device drivers, and in fact we'd like to remove
>>>> it tree wide eventually.
> 
> Just for info: loopback.c uses it too :-)

Yes, we're all aware of this.  Google for "david miller loopback lltx" 
for a few examples...

Also, please do not strip CC's, that's quite annoying.

	Jeff



