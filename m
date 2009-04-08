Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbZDHM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbZDHM5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZDHM5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:57:04 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38632 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760037AbZDHM5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eAVeYu0V8bui3NEQgLgNQYMkMQIqTKTO6d5F5DKpmZe1kOG1BSVXw8FPM97fRjQaui
         qUy/uSlnEkX7fSWzMkTV3ITI3U0RB7uY+PckiH3YzNgyjId4FdwynwSl4IxIMXoXbhd5
         cEWCFAc34t1YAPF17W0QS6AH524wVGTLD+iLM=
MIME-Version: 1.0
In-Reply-To: <20090407103611.GA5910@elte.hu>
References: <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
	 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	 <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>
	 <003001c9b6ff$a9259ce0$fb70d6a0$@com>
	 <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
	 <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain>
	 <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
	 <10f740e80904070051u4ec81842u931a405ab5bde985@mail.gmail.com>
	 <20090407103611.GA5910@elte.hu>
Date: Wed, 8 Apr 2009 14:56:59 +0200
Message-ID: <1158166a0904080556n29daf102wec5689cf12b4b81f@mail.gmail.com>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Apr 7, 2009 at 12:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> allmod/allyes will enable all sorts of legacy options.
>
> Since besides myself i'm not aware of any other person on this
> planet actually _booting_ allyes/allmod Linux kernels,

Does allyesconfig boot? Any funny effects?
--
vda
