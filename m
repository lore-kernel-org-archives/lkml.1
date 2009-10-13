Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbZJMNAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbZJMNAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbZJMNAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:00:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:9486 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759530AbZJMNAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=iaGWybNXtHa20N7cuCzr933yQqO5hMl/6g8q5ydPOI5M6Jz8mHw3OkOy4wIroPpKN/
         ecI7ETr/xAVNp/PJ1WitE8q9HsunTa4uajFtg1UT1Cpq9dvCmVS0dGOPx5GbA40Y5+Mj
         7aSVd5apeXS0jgtDhT3l7dzcrQ6kL/FoZ8R9A=
MIME-Version: 1.0
In-Reply-To: <4727185d0910130548p325f0185vf4e23b5491c730a0@mail.gmail.com>
References: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
	 <20091013100101.GA26846@elte.hu>
	 <4727185d0910130451h3a5adcebtc0c06f48b6c9ab99@mail.gmail.com>
	 <20091013122720.GA5561@elte.hu>
	 <4727185d0910130548p325f0185vf4e23b5491c730a0@mail.gmail.com>
Date: Tue, 13 Oct 2009 15:58:56 +0300
X-Google-Sender-Auth: a7befb85cd997136
Message-ID: <84144f020910130558y1fe27de7q378286e60b69e883@mail.gmail.com>
Subject: Re: [PATCH] [PERF] do not manually count string lengths
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, paulus@samba.org,
       a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Tue, Oct 13, 2009 at 2:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>> Was your list really comprehensive ?
>>
>> ah, yes - perf_callchain.c too indeed. The pattern does not have to be
>> 100% full coverage.

On Tue, Oct 13, 2009 at 3:48 PM, Vincent Legoll
<vincent.legoll@gmail.com> wrote:
> How looks the attached ?

Can you please send patches as plain-text in the future? Attachments
are pain to review on some email clients (such as mine).

                        Pekka
