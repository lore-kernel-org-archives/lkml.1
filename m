Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZBVN6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZBVN6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBVN6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:58:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:13414 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBVN6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:58:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LIEhBChp2kuVcu1w6kii7H8OXova/H09TvKqEfiEDJ5C/lL2myLHj36/EYDFUg4U1a
         hBWWuUB0ecyb5F7ltG/bM1JCPZk6MLN63km3Sdw4v1papySoLElB3dHVUgEQSBB5qzhG
         KrX2nhjJLxUA8HA5jpsRXwnjxaytWXTLZSoTM=
Date: Sun, 22 Feb 2009 21:58:18 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
Message-ID: <20090222135818.GA12782@hack.private>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.Y3B.t50lJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ROx6X68CGJG.A.Y3B.t50lJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 09:50:19PM +0100, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of regressions introduced between 2.6.27 and 2.6.28.
>
>The following bug entry is on the current list of known regressions
>introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>be listed and let me know (either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
>Subject		: uml is very slow on 2.6.28 host
>Submitter	: Miklos Szeredi <miklos@szeredi.hu>
>Date		: 2008-12-12 9:35 (65 days old)
>References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4

Hello, Miklos!

I can't reproduce this on host 2.6.28.7 with uml guest of current git.
Have you tried 2.6.28.7? Does it have the same problem?

Thanks.


-- 
"Against stupidity, the gods themselves, contend in vain."

