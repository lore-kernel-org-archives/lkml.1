Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXBOLGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXBOLGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965847AbXBOLGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:06:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:1692 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965632AbXBOLGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KMHYDfSDXK+0XZtRR6BSqTxEVJTaDb4HbqJRy9rPSv+HE/6cEG33IuLKso1SIe8PMbF++/9UJ2gryKIemgCAQdhWjkW7ZV4T/bpRVySrRdWpY8Q9mSrugbk075+QE9V0RIl57l7mAtckl8bw/UKXLM20o+K+96CnAPyuSH+zHLk=
Message-ID: <efa6f5910702150306v180bf810o15fbfe6c781f43ad@mail.gmail.com>
Date: Thu, 15 Feb 2007 12:06:35 +0100
From: "Ihar `Philips` Filipau" <thephilips@gmail.com>
To: "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Our source code is meaningless to the Open
> Source community at large. It is only useful to our tiny set
> of competitors that have nothing to do with Linux. The Embedded
> space is very specific. We are only _using_ Linux. Just as we
> could have used VxWorks or OSE. Using our source code would
> not benefit anybody but our competitors.

What a load of B.S. I'm working with embedded Linux for five years and
hear that shit more or less every day. Is it mantra for happiness here
or what?

That's TOTALLY wrong. You basically are saying that your main
competitors are your own customers. People do with stuff absolutely
unpredictable things creators often even cannot think about. And then
they become your /competitors/. That what is called "innovation".

Linux precisely thriving, since it gave power back to consumers - and
allowed them to use things they have bought to their fullest. Few
people can clearly state what they need - and Linux allow them (w/o
thinking hard formulating on bug report to you - and sparing your time
on guessing what user really wants) to take it and adopt it to their
own needs. I have customers who did absolutely crazy things with
embedded systems - putting to better use those few resources original
system had left redundant. (Just recall LinkSys' WRT54G - and it is
just but one of the examples. In corporate world it is also happening
all the time - just let customers in.)

Also, to the question of "not benefit anybody". I have seen piles of
rare/obscure hardware which is rare/obscure precisely because there
are no drivers for it. And guess how hardware/OS selection works:
primary question is availability of ready drivers and/or effort it
would take to adopt existing drivers. This is vital part of embedded
system costs: engineering costs. Your vendor had driven itself into
lock-in: you have unique drivers for unique piece hardware and costs
cannot be cut because hardware doesn't become commodity. And it can't
become commodity (nor can be standardized) due to lack of open
drivers.  ".. and I've seen it before, .. and I'll see it again" (c)
Propellerheads.

-- 
Don't walk behind me, I may not lead.
Don't walk in front of me, I may not follow.
Just walk beside me and be my friend.
    -- Albert Camus (attributed to)
