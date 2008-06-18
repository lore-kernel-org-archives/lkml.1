Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYFRX1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYFRX1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYFRX0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:26:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:56829 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYFRX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JIbelzADTUVUb8Xu7m7ZJu8mY5z3X45rkDwiOjPy8gtqWzeD3tANX8T2GBeoqUTfHb
         lmnjdvOz2VspGTpqSEC7P9Qip/aFSizeeJXfUP8wlu+BAELMXGP9zEGfOPJYBxfBUBa1
         JwA7AEzh34KBydzXWfgrXnuwDWVFoNBOGMkFI=
Message-ID: <74d0deb30806181626p621897f5td654170daa762f34@mail.gmail.com>
Date: Thu, 19 Jun 2008 01:26:49 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Samuel Ortiz" <sameo@openedhand.com>
Subject: Re: [PATCH] asic3: move probe functions into __init section
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080618212035.GD22566@caravaggio>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213810349.8144.11.camel@localhost.localdomain>
	 <20080618212035.GD22566@caravaggio>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 11:20 PM, Samuel Ortiz <sameo@openedhand.com> wrote:
> Hi Philipp,
>
> On Wed, Jun 18, 2008 at 07:32:29PM +0200, Philipp Zabel wrote:
>> Potentially free some memory by moving the _probe functions into __init.
>>
>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> This one looks good to me, I'll submit push it to -mm as I'd prefer asic3
> patches to go through there first.

That's fine with me, thanks.

regards
Philipp
