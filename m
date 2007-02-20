Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbXBTMHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbXBTMHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 07:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXBTMHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 07:07:15 -0500
Received: from smtp.nokia.com ([131.228.20.173]:46426 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbXBTMHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 07:07:14 -0500
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070219233440.GC5691@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217224952.GB16522@thunk.org> <1171889303.13817.29.camel@sauron>
	 <20070219143321.GE25490@thunk.org> <1171904866.14817.36.camel@sauron>
	 <20070219233440.GC5691@thunk.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 Feb 2007 13:54:06 +0200
Message-Id: <1171972446.4039.13.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 11:54:06.0339 (UTC) FILETIME=[D2BFFD30:01C754E5]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220135036-69904BB0-1B800F2D/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 18:34 -0500, Theodore Tso wrote:
> Not that my opinion is the only
> one you need to pay attention to, but if everyone is telling you that
> need to simplify the number of interfaces, you may want to listen
> since your code is going to need adequate review if you want to get it
> into mainline.

Theodore, thanks for even more vivid explanation. As I wrote, point
taken. I was probably vague, sorry, but let me say this more bluntly: I
will think how to change this. At the very least I _will_ dispose of 3-5
units and the situation will be better.

Thank you,
Artem.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

