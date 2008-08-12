Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYHLXri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYHLXri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYHLXra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:47:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7402 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYHLXr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:47:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Qj04by9emquq23Zgdagsuf1Fg7nb/3VI2XPVhYkOeWQlTgqdYoLcDZ6nCJ2bHT7MH
	XEXnV+tkR/Ym//hB6aGwQ==
Message-ID: <33307c790808121647j4feef841i23638dba40197648@mail.gmail.com>
Date: Tue, 12 Aug 2008 16:47:15 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Panic on boot for x86_64
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200808122223.29022.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790808121251t79af0fajf44cebffa8938051@mail.gmail.com>
	 <20080812131045.b89e98b1.akpm@linux-foundation.org>
	 <86802c440808121313x26e46c00m9ec6cd73b3bdbf22@mail.gmail.com>
	 <200808122223.29022.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> please try tip/master, or wait a while after linus pull fix from tip x86 fix.
>
> The fix is in the mainline already.


Still looks broken to me (rc2-git5)

http://test.kernel.org/results/IBM/188946/debug/console

It got in since yesterday?
