Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZKLVtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZKLVtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbZKLVtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:49:33 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:57708 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZKLVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:49:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NwBzXkGyDi+qZsw8S/bHamlVzfVO/LGoRiuq+S/kyWbVs/ti2r6Z3FhPiyvsMlpSyb
         wWGuTt6StUW0Rtc+I4sS8h1n3dgdNvit7/THj/pJhSxlMdDpFArfq3tWPYxbbiz7kdPd
         SIWp7EvEylSWr5DzS15YKQzRZ1l3KSFoeYocI=
Message-ID: <4AFC8285.2040804@gmail.com>
Date: Thu, 12 Nov 2009 22:47:49 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Caleb Cushing <xenoterracide@gmail.com>
CC: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: large packet loss take2 2.6.31.x
References: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>	 <20091112113836.GA7963@ff.dom.local> <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com> <4AFC5C58.9030207@gmail.com>
In-Reply-To: <4AFC5C58.9030207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote, On 11/12/2009 08:04 PM:

> Caleb Cushing wrote, On 11/12/2009 02:46 PM:
...
>>> Btw, you didn't send the stats you compared, and your wireshark dump
>>> doesn't show anything wrong either.

...

>> I didn't see that sorry. I wasn't sure if the dump would or not (I'm
>> not a networking expert, just know more than the average joe).


Hmm... I didn't see that either, sorry! After re-checking I can see
unanswered requests in this dump. Anyway, the main thing to test now is
the first hop to 192.168.1.1 (some info about it?), as I wrote before.

Jarek P.
