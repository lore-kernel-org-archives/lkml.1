Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZBDPX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZBDPX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZBDPXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:23:49 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:60561 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZBDPXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FdNea7/JvVmbneQbgv227U6u0lXj6qKA5J77RvkLrJ6GYVJovsigsUfrb1AQUjesa3
         cn7Al9wueICffhe2jRLgGCTbPs5vjVAzhZRViXavNgLpgr0F54d/6K/Eocjm9cbBqhOu
         BOaT21uZn3MIaDvOkT/P1URSiZhH8b8M2PCHU=
MIME-Version: 1.0
In-Reply-To: <pWZw1SZjMCH.A.nXG.evYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.nXG.evYiJB@chimera>
Date: Wed, 4 Feb 2009 07:23:46 -0800
Message-ID: <dd18b0c30902040723m70f87f7fp4af32702410036d7@mail.gmail.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
From: Justin Mattock <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>, Justin Madru <jdm64@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 2:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12505
> Subject         : 2.6.29-rc1 Firefox crashing on page load
> Submitter       : Justin Madru <jdm64@gawab.com>
> Date            : 2009-01-16 20:56 (20 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4217458dafaa57d8e26a46f5d05ab8c53cf64191
> References      : http://marc.info/?l=linux-kernel&m=123213941914274&w=4
> Handled-By      : Justin P. Mattock <justinmattock@gmail.com>
>
>
>

Well the hardest for this, was to reproduce
the error.(never did). I guess it can be taken
of if there was a patch for the fix, and the patch
made it into the main tree. but if this  is a firefox
issue, then a report needs to be filed with them.
so overall my answer is "I don't know."
:^)

regards;
-- 
Justin P. Mattock
