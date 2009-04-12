Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZDMJT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZDMJT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZDMJTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:19:47 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:45718 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZDMJTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZqyAr+HvwYHnhx0z4Rx9pd1Q8C9g9LefpVF8udSPcd4nwJZrY07OOOBT7JYwRo/UeP
         JwHI9+qZhHiS7Qt9LjMUEF+Z9UFXc2LgbjRygMlRLTuT90JYO9K85980ptIEcdEuhKbi
         pGek07oHY03wzOdru5igr24di5dbC3mivgaV4=
Message-ID: <49E22ED9.40100@gmail.com>
Date: Sun, 12 Apr 2009 11:11:37 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: v2.6.25: WARNING: at kernel/lockdep.c:2437	__lock_acquire+0xc69/0xfa0()
References: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com> <1208782090.7115.179.camel@twins> <480FF821.9050208@gmail.com> <49E0C102.4020705@pobox.com>
In-Reply-To: <49E0C102.4020705@pobox.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> (going through old, unresolved email)
> 
> It looks like this might still be needed?  I never saw an "it works"
> response to this email.

Indeed.  Peter Zijlstra, can you please test it?

-- 
tejun

