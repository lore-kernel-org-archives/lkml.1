Return-Path: <linux-kernel-owner+w=401wt.eu-S1759802AbZATSNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbZATSNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZATSNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:13:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:6989 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZATSNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:13:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ghJ3pAJ/woucyLx7UvhP4rlamaFLb1RhVZLI5gcX4UFyzhFI8Amb8Tmg3h5BMTWZG9
         dhmwQYrxx2ua8LiyUROl/oiUnq07mUBc5gyRQHg2GCvQzhnb1nXtPjE3cXUU9XHMD55i
         4f+9NdiY2mVh9KYQx1zlyEOxBEPBabJ/3u7Qs=
MIME-Version: 1.0
In-Reply-To: <cX2gZ6Cy9nC.A.SID.GKRdJB@chimera>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	 <cX2gZ6Cy9nC.A.SID.GKRdJB@chimera>
Date: Tue, 20 Jan 2009 13:13:40 -0500
Message-ID: <81bfc67a0901201013p46967ecfgb69353df51fc50d8@mail.gmail.com>
Subject: Re: [Bug #12264] i915: switching from kwin in opengl mode to a VT 
	then back to x11, x11 freezes
From: Caleb Cushing <xenoterracide@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugs.freedesktop.org/show_bug.cgi?id=18879

fixed here and verified fixed in gentoo. Not sure if the kernel
patches have made it into vanilla-sources. If they have +libdrm fix,
it works.

On 1/19/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
>  of regressions introduced between 2.6.27 and 2.6.28.
>
>  The following bug entry is on the current list of known regressions
>  introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>  be listed and let me know (either way).
>
>
>  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12264
>  Subject         : i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
>  Submitter       : Caleb Cushing <xenoterracide@gmail.com>
>  Date            : 2008-12-16 11:40 (35 days old)
>  References      : http://marc.info/?l=linux-kernel&m=122942777030666&w=4
>
>
>


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
