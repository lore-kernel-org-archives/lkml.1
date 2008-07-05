Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYGEKzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYGEKzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYGEKza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:55:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52217 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYGEKza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:55:30 -0400
Message-ID: <486F531E.6030303@firstfloor.org>
Date: Sat, 05 Jul 2008 12:55:26 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/9] MCE: Use 64bit machine check code on 32bit
References: <200807041120.678642023@firstfloor.org>	 <20080704212033.D40551B431F@basil.firstfloor.org>	 <36ca99e90807050250u718fa277t2297d6436fd14c4e@mail.gmail.com>	 <486F44C0.8050003@firstfloor.org> <36ca99e90807050317m7160c3eaj150ceac4440752a1@mail.gmail.com>
In-Reply-To: <36ca99e90807050317m7160c3eaj150ceac4440752a1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Sat, Jul 5, 2008 at 11:54, Andi Kleen <andi@firstfloor.org> wrote:
>>> Is this first "n" a typo?
>> No. The legacy machine check code that is going away is definitely
>> supposed to be default n. This is effectively a default y for
>> the new code.
> I didn't mean the "default n", but the "If you're still sure you want it, say n"

Ah that's indeed not correct. Thanks.

-Andi

