Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZEYMny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZEYMny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZEYMnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:43:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:52464 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZEYMnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ZACdY1/fHyDq71Q/6jGhpqE7BdQu5K7+AIaVq0O1Ryr/ZLqO664hMeH+U008gPPgRW
         7tbsP40L2nAk+yBecJOILiqJA+i82FG04mphbTyQusFBV1qjJWIlwO/daGR5ezgV5loh
         36V+OBgizpaPeSmuEOY7qtiaGTt3QhjOfDS7s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
Date: Mon, 25 May 2009 14:48:40 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard Atterer" <richard@2009.atterer.net>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.51C.SQcGKB@chimera>
In-Reply-To: <WCcYF-TAbJC.A.51C.SQcGKB@chimera>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905251448.40907.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 May 2009 21:31:20 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).

Yep.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13371
> Subject		: s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
> Submitter	: Richard Atterer <richard@2009.atterer.net>
> Date		: 2009-05-16 22:51 (9 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=295f00042aaf6b553b5f37348f89bab463d4a469

Nope.

> References	: http://marc.info/?l=linux-kernel&m=124251446428166&w=4
> Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Casually-Handled-By
