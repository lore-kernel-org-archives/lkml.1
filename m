Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZBOGGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZBOGGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 01:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZBOGGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 01:06:05 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:49698 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZBOGGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 01:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kG1hctRJ5iIHs6KxKOBDhVeZyJvhrRWr2nkU3cYyR3Millw6pfPmueiXtwiSWqeJMV
         eyBrVXxCnWu1i1TnBIc93rEziD10JCnPN5ph2HO+ak2rZmCDTPB2ICWBwIbbrtbUECPW
         cSqka5E9R5BYDVO5QSY/JZd6coTJ4MHGctqeI=
Date: Sun, 15 Feb 2009 11:14:46 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan Opmeer" <arjan@opmeer.net>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [Bug #12406] 2.6.28 thinks that my PS/2 mouse is a touchpad
Message-ID: <20090215111446.789c1f8a@home.aephome.ru>
In-Reply-To: <ROx6X68CGJG.A.Ql.E50lJB@chimera>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
	<ROx6X68CGJG.A.Ql.E50lJB@chimera>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still
> should be listed and let me know (either way).

Yes, it is still a regression with a patch that is not in -stable.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12406
> Subject		: 2.6.28 thinks that my PS/2 mouse is a
> touchpad Submitter	: Alexander E. Patrakov <patrakov@gmail.com>
> Date		: 2008-12-27 9:06 (50 days old)
> References	:
> http://marc.info/?l=linux-kernel&m=123036893817280&w=4
> Handled-By	: Arjan Opmeer <arjan@opmeer.net>
> Patch		:
> http://marc.info/?l=linux-kernel&m=123092147703236&w=4

-- 
Alexander E. Patrakov
