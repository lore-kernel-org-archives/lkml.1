Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZKVO63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZKVO63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 09:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZKVO62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 09:58:28 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64155 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbZKVO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 09:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=T8ZzkAt1QM72kH51PkWk2Kyw5jU7F1CU4IFe4dDKL/ZY+3/kOqFcXBuknmaMTBy2B8
         dgI6z9BlL2W3zKXe7Xom2FQS1Nh+pi8DbpZtC2YGEmZhn9proLH9DatIyb2xShhcD0ye
         Ce8rvC8YaIuxtfo3XQiplUnxxXzaHrQLijdD8=
Message-ID: <4B0951CB.20607@gmail.com>
Date: Sun, 22 Nov 2009 06:59:23 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5
 cr2 0
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera> <l2_yP_tdgYK.A.32C.e7_BLB@chimera>
In-Reply-To: <l2_yP_tdgYK.A.32C.e7_BLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2009-10-23 16:45 (30 days old)
> References	: http://lkml.org/lkml/2009/10/23/252
>
>
>
>    
yes It's still there.. I'm wondering because
there's not much feedback on this maybe I should take
a hint! or maybe it's something people just don't
understand, and don't have time for.. In any case
I'm still looking at it(although had to look at other
reports as well).

Justin P. Mattock
