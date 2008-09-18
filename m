Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYIRXE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYIRXE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYIRXEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:04:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:6489 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYIRXEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:04:48 -0400
Message-ID: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
Date: Thu, 18 Sep 2008 16:04:47 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
	 <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 3:08 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Sep 18, 2008 at 3:01 PM, Luis R. Rodriguez
>
>>> Which is far more important, I agree. It's annoying to get speeds
>>> <802.11b on my pre-802.11n capable chipset and network. ;)
>
> Oh and you should at least get some 11n rates, just not aggregation :)
>
>  Luis
>

I always get "1 megabit/sec". It actually measures (at best) to be a
throughput of 8mbits/sec, though the average (due to strange random
packet loss) is about 4mbits/sec. -- And that was with aggregation
re-enabled via your patch. Without, it never exceeds 1mbit/sec
(actual, not just as indicated by iwconfig.

- Steven
