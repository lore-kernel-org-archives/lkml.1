Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbZJBPdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbZJBPdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbZJBPdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:33:01 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:54306 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZJBPdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:33:00 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 11:33:00 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j4aYzhZMM42Od3SvLhzujb/dBOx2wp7aTKgQfnukbhjDS9fFzCmNefV511wv+IJjeZ
         EeUUfk/Rry908B6xPSWe1SqozjV/c7mMU7BMLvV5TnkjPruwh6I8v9L44rwUNLe53UE1
         Mjvtdmg8ENrFqZL9ztxWFvsBx8olCm+nQ98rA=
MIME-Version: 1.0
In-Reply-To: <20091002124921.GA4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
	 <20091002124921.GA4494@redhat.com>
Date: Fri, 2 Oct 2009 17:27:55 +0200
Message-ID: <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
Subject: Re: IO scheduler based IO controller V10
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>, Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 2:49 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Oct 02, 2009 at 12:55:25PM +0200, Corrado Zoccolo wrote:
>
> Actually I am not touching this code. Looking at the V10, I have not
> changed anything here in idling code.

I based my analisys on the original patch:
http://lkml.indiana.edu/hypermail/linux/kernel/0907.1/01793.html

Mike, can you confirm which version of the fairness patch did you use
in your tests?

Corrado

> Thanks
> Vivek
>
