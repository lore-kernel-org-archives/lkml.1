Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYGMXy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYGMXy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 19:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYGMXyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 19:54:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbYGMXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 19:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u0nVmPwZ8JCl1pCd0FjvmD/53WXFYTmbVjteOsOleZL1aNy6n2TIVOEaK8qEJ4yNHF
         NdVm3JczLsKRwXnaZs1VngCkNi1G1tpM/4ztY/PKDLGUGrh3M4tKFXHBYNUl2lNJpLVw
         swnR+vDGhh8ldSiZ8dHqouR1A5LfgsLgzoTbE=
Message-ID: <6101e8c40807131654q24e9f3ffo3f4cec179c355c89@mail.gmail.com>
Date: Mon, 14 Jul 2008 01:54:19 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       Kurk <kurk@shiftmail.org>
In-Reply-To: <c6ZRbn0adb.A.jkH.RHleIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.jkH.RHleIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think, fixed by 27898988174bb211fd962ea73b9c6dc09f888705

On 7/13/08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11045
> Subject		: Bug in MPT Fusion 2.6.26-rc7 unbootable
> Submitter	: Kurk <kurk@shiftmail.org>
> Date		: 2008-07-06 11:22 (8 days old)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
