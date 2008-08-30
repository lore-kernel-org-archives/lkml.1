Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYH3SLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYH3SLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYH3SLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:11:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:41944 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYH3SLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rqfgh3KF+Oobx8z0vvQVKvwwQd9+LMpTCpmgy9t/o7kcZYrHU2lPjz+rwB5Mpu98nP
         TqsnPpwRpDtqX34Wu+KXsloXzaiTWb2BV25mkyHeDlnxPzl+ueeiPerB867jwdNUajA7
         uiCqB+wlAdUA+rUIro5Po6TEO+Yx/99utGaNE=
Message-ID: <86802c440808301111i2880a13eq61155b8c7b1ed3dd@mail.gmail.com>
Date: Sat, 30 Aug 2008 11:11:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <86802c440808301055o1a8bc6a9iddbc066f016ef6d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808301532.57307.rjw@sisk.pl>
	 <86802c440808300905v5056fe0apdc6e328d99dff090@mail.gmail.com>
	 <200808301915.00381.rjw@sisk.pl>
	 <86802c440808301055o1a8bc6a9iddbc066f016ef6d6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 10:55 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Aug 30, 2008 at 10:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>>
>> Could you please rebase them on top of current -git?
>
> please check attached quilt series based on linus tree.

there is some problem with fix -v4...on one test machine.

please don't use it now

YH
