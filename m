Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYGGHPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYGGHPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYGGHPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:15:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:23819 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYGGHPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D4OLpqzgHqV53Zq2xkUn+tr94gCeG7P0lJ5SQ6a2sd7OwaMAfjsEX3OfjdBqo8xYdr
         LN6b8lEHy8Mq5avZaSrtTdHdl/37g53/1kbwrEHnB1wuW2cnKIvunb/UbwmYlrpfnIWn
         Yg4KgZ5slQxDf+4H9RwzrqCTttqTbz3Xya97w=
Message-ID: <86802c440807070015qbfdbf08s62ce5c37092d0fb5@mail.gmail.com>
Date: Mon, 7 Jul 2008 00:15:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <20080707064227.GA27622@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.XLC.s0LcIB@albercik>
	 <20080706111750.a6d77e81.randy.dunlap@oracle.com>
	 <20080707064227.GA27622@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>> This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.
>
> one thing i dont see you having followed up on is whether tip/master
> works fine:
>
>  http://lkml.org/lkml/2008/6/11/355

in the response to me, he said tip/master has the same problem

YH
