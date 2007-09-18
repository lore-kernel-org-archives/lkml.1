Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbXIRR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbXIRR3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbXIRR3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:29:15 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:35398 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXIRR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:29:14 -0400
Message-ID: <46F00AA8.4090806@gmail.com>
Date: Tue, 18 Sep 2007 19:28:08 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: Dmitry Torokhov <dtor_core@ameritech.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ucb1400_ts.c -- replace an interruptible sleep with an
 uninterruptible one
References: <46EFE66A.9090400@gmail.com> <alpine.LFD.0.9999.0709181203190.26525@xanadu.home>
In-Reply-To: <alpine.LFD.0.9999.0709181203190.26525@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2007 06:03 PM, Nicolas Pitre wrote:

> On Tue, 18 Sep 2007, Rene Herman wrote:
> 
>> Hi Nicolas.
>>
>> Given that it's not checking for signals, I believe this one should be an
>> uninterruptible sleep instead?
> 
> Probably.

Thanks. Should I send it somewhere or will you or Dmitry grab it?

Rene.
