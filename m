Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYH1Baw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYH1Baw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYH1Bak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:30:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:22309 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYH1Bai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qaOF/N7fkhU/fSjGNMMGC3GoP5VTYa7gOlptiGPiTnNtsSpYKivdRbZmNy1feFwieT
         sn/3JM91WqAf+qFQDLokjZ9JMFkRf74pQTchEJNV1ZSLR6lqqO9lcrH+Fy8+zoW5r9uF
         DG1LypIM8BhJ94OxJfnxp93eUvrwz6hvosmgM=
Message-ID: <43e72e890808271830k6e0a9e65j790ee1e0d6d52d36@mail.gmail.com>
Date: Wed, 27 Aug 2008 18:30:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bruno Randolf" <bruno@thinktube.com>
In-Reply-To: <1ba2fa240808271719o2a3617e7re0499670de785b2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827013009.GA15781@tuxdriver.com>
	 <1ba2fa240808271226i95a7789k481a68b09dc60164@mail.gmail.com>
	 <200808272225.10557.mb@bu3sch.de>
	 <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
	 <20080827233103.GE5927@tesla>
	 <1ba2fa240808271719o2a3617e7re0499670de785b2f@mail.gmail.com>
X-Google-Sender-Auth: acba1f5a8e1d97f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 5:19 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> This patch is marked as W/A and should have
> probably some cleaner solution in 2.6.28

OK

>>> Last solution would be to remove this merging all together
>>
>> Absolutely not! IBSS merge is per spec, otherwise you don't really have
>> a real IBSS.
>
> I'm all for following spec and we've tried really hard to make it work.
> Anyhow I'm not sure what you call real IBSS. nobody has checked it for
> 1.5 year this patch  is in and now is suddenly so important...

I don't care about your work around, I was replying due to your insane
comments about considering removing IBSS merge support because your
hardware does not support it well.

> I would like to see if there is any  HW under mac80211 that actually
> work with this.

Atheros hardware supports IBSS merge, please consider a proper work
around instead for hardware which does not support this.

  Luis
