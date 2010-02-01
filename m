Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0BAHP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:15:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:61018 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab0BAHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QAuDbjgIYp1Btg+kFA3Frx+Izo0aNFTidnHjuPPGNWe/ZavlDCfD2ppPnscXgdYuJS
         hrSuR4vaSN7eUXE/RsxiLww0WcrxrX61nAt19IcaNCkWZ6+i7FS3n5PhaEh0a6SWDi4z
         Y536MrsQHXkjyD2iWrLJBItOm6nwyV36tDvcI=
MIME-Version: 1.0
In-Reply-To: <d3IDKWHT5gE.A.CjC.57hZLB@chimera>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.CjC.57hZLB@chimera>
Date: Mon, 1 Feb 2010 08:15:54 +0100
Message-ID: <c2673ca61001312315s3e50611fm81171ddca6d19477@mail.gmail.com>
Subject: Re: [Bug #15076] System panic under load with clockevents_program_event
From: okias <d.okias@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still valid. But reproduction without HIGHMEM is minimal, but still annoying.

2010/2/1, Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15076
> Subject		: System panic under load with clockevents_program_event
> Submitter	: okias <d.okias@gmail.com>
> Date		: 2010-01-17 13:03 (15 days old)
>
>
>


-- 
Jabber/XMPP: okias@isgeek.info
SIP VoIP: sip:17474537254@proxy01.sipphone.com
