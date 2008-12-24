Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbYLXAIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbYLXAIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 19:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYLXAIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 19:08:24 -0500
Received: from main.gmane.org ([80.91.229.2]:33380 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYLXAIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 19:08:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: malc@pulsesoft.com
Subject: Re: Lock-up on PPC64
Date: Wed, 24 Dec 2008 03:08:15 +0300
Message-ID: <871vvy77v4.fsf@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru> <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru> <20081223234513.GA8730@deepthought>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83.167.112.74
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
Cancel-Lock: sha1:dXh9BCioYbF1DeTC2+vFXObS3V0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Moffat <zarniwhoop@ntlworld.com> writes:

> On Tue, Dec 23, 2008 at 06:04:45AM +0300, malc@pulsesoft.com wrote:
>> 
>> I don't know where to get PPC64 capable memtest, even if it exists the
>> probability of two different machines exhibiting almost the same
>> behaviour is rather slim. Netconsole doesn't catch anything. In fact
>> i just had slightly different situation where after ssh connection was
>> killed i was able to reconnect and look at dmesg there - nothing.
>> 
>  If you wanted to, you could get memtester from
> http://pyropus.ca/software/memtester/ - not as convenient as
> memtest86 etc (it's just a userspace task, so it can't test all the
> memory), but it did work on ppc64 last time I tried it (nearly 2
> years ago).
>

Thanks for the reference, but i'm sure, now more than ever, that bad
memory has nothing to do with it, all signs are there that kernel is
confused by the way signals are (mis)used by Mono.

-- 
mailto:av1474@comtv.ru

