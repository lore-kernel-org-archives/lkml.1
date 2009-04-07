Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbZDGDbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbZDGDbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZDGDbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:31:40 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61228 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZDGDbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vjOxnhgm/FgRw6+ChDiF9Txr9nYiT1SoiheBQwLKmqYnmIS0K264+Zwco0HoHtQcJc
         oo2Sp9TtDMeX6uDlUqA4mUAvcOQ917KR2Qfm/pyGSovYz90rfdHtN3AZJLZ8qLSSSO2W
         A98Vh8jSUsfM0FxrZ7cbIQU+BLY2bZs/YjP9o=
MIME-Version: 1.0
In-Reply-To: <AsKNxFx2juN.A.gjH.4Fn2JB@chimera>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.gjH.4Fn2JB@chimera>
Date: Tue, 7 Apr 2009 07:31:36 +0400
Message-ID: <aa79d98a0904062031x321bd160rd89b19a6a49fe760@mail.gmail.com>
Subject: Re: [Bug #13015] pppoe over ethernet
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Detlef Tschirschky <detlef.tschirschky@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13015
> Subject		: pppoe over ethernet
> Submitter	: Detlef Tschirschky <detlef.tschirschky@gmx.de>
> Date		: 2009-03-25 21:28 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=123801663105671&w=4
>
>
>
I expect the issue is inspered by network problem found in plain
2.6.29. Detlef could you confirm the problem is still active in
2.6.29.1 or in current -git mainline?
