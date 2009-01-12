Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZALAnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZALAnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 19:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZALAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 19:42:55 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50639 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZALAmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 19:42:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DcbVTx/dbtm1Y3fVptxavIseBMzYdXagT1/uiWDPqhpwXROZNy6xDqrI4twPamr9CF
         J497qXWk4vHDgK3vcSkcmoZEyS+YgEKFgZN08qc4Jd58KGkAhJ6jYc+t5gqnq1NbIPTJ
         HEaPSrxyixG+HavSMhKw4wEO9RvTdhQfOQxTI=
Message-ID: <81bfc67a0901111642i37f46edar8592899d7193b863@mail.gmail.com>
Date: Sun, 11 Jan 2009 19:42:51 -0500
From: "Caleb Cushing" <xenoterracide@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12264] i915: switching from kwin in opengl mode to a VT then back to x11, x11 freezes
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <nHCfeC0YLrE.A.ncC.2afaJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
	 <nHCfeC0YLrE.A.ncC.2afaJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so far I'm tracking with gentoo here.
http://bugs.gentoo.org/show_bug.cgi?id=253813 and freedesktop here
http://bugs.freedesktop.org/process_bug.cgi

and I've tested the first 2 kernel patches alone, and still have the
issue, haven't been able to add the libdrm patch to libdrm so far.

On 1/11/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
>  Date            : 2008-12-16 11:40 (27 days old)
>  References      : http://marc.info/?l=linux-kernel&m=122942777030666&w=4
>
>
>


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
