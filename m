Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZDGImG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZDGImG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZDGIly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:41:54 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40574 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZDGIlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kI3v7LDNrBsYbCkFZMW6Q/aYZ3kyNVXlkSh/UIKmVQZivo8mR9gS4OQMu5NJy/4JWG
         iGBjhJImVYSQgfDu3kKNBIaJ06xk83MW2J0xVAC+RFmwuqChGOqhH+SZwpGCxNvUsgtQ
         0XRMatbada35b1SOoJNSP/EFYr0FyEmw4rKSQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0904071020380.7197@speedy.coe.org>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.gjH.4Fn2JB@chimera>
	 <aa79d98a0904062031x321bd160rd89b19a6a49fe760@mail.gmail.com>
	 <alpine.LNX.2.00.0904071020380.7197@speedy.coe.org>
Date: Tue, 7 Apr 2009 12:41:49 +0400
Message-ID: <aa79d98a0904070141r45d752dana00cebb381b72c4c@mail.gmail.com>
Subject: Re: [Bug #13015] pppoe over ethernet
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Detlef Tschirschky <detlef.tschirschky@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/09, Detlef Tschirschky <detlef.tschirschky@gmx.de> wrote:
> On Tue, 7 Apr 2009, Cyrill Gorcunov wrote:
>
>> On 4/6/09, Rafael J. Wysocki wrote:
>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13015
>>> Subject	: pppoe over ethernet
>
>> I expect the issue is inspered by network problem found in plain
>> 2.6.29. Detlef could you confirm the problem is still active in
>> 2.6.29.1 or in current -git mainline?
>
> Moin Cyrill,
>
> 2.6.29.1 is running fine for me. Can't find any network problems in
> 2.6.29.1 now.
>
> Thanks and regards
>
> Detlef
>
>
Thanks a lot, Detlef!
Rafael, i guess we could close the bug.
