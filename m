Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZKQAU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZKQAU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZKQAU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:20:56 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:43443 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZKQAU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:20:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yCQ9D0atiiQivIZgx5EPDn8wts+jJP3YJZk3KASUNQouYJTDwk32i0hU878/GQee1g
         LjobsGiuyp/W10s9cQMlK4ZjivS2gSXz9YDRlov7R1VxMtrEMeB/WJXszEXqgkWzzOfD
         k8Hw53vNMi5DzMjNMXQu1JVb7YKdgRjActhrs=
Message-ID: <4B01EC95.7070109@gmail.com>
Date: Mon, 16 Nov 2009 16:21:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [Bug #14483] Interrupts enabled after irqrouter_resume - iMac9,1
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.-yG.OTdALB@chimera>
In-Reply-To: <xXQGFmujPl.A.-yG.OTdALB@chimera>
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
> Subject		: Interrupts enabled after irqrouter_resume - iMac9,1
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2009-10-25 19:58 (23 days old)
> References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4
>
>
>
>    
I have to say that doing a bisect on this
was more than I had anticipated.
(still need to go through and revert commits,
to see if I can find exactly where).

So yes this should still be open.

Justin P. Mattock
