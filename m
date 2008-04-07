Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbYDGXoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbYDGXoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYDGXoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:44:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:39858 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYDGXo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aZhdNlwX9SIcW1uQgUWC1cG14x9Ded6edFMaMrdofJoJJoWejbPxsICK8W2euqf0aQ5vsgkiI0Nuiuw2CUIWZzHU++ElDpTVwUFBoiwo8sp4fIcMknuEkoXgAgZXibNoDyBgRXVitujiypYQ398s+vQ42zCQ0NvxGfeEX10y/OE=
Message-ID: <5a4c581d0804071644u6922d412i943c0094dc7e2601@mail.gmail.com>
Date: Tue, 8 Apr 2008 01:44:26 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
Cc: LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <200804071459.35628.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200804071459.35628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/7 Rafael J. Wysocki <rjw@sisk.pl>:

>  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10384
>  Subject         : 2.6.25-rc6-git2: warn_on_slowpath for tcp_simple_retransmit
>  Submitter       : Alessandro Suardi <alessandro.suardi@gmail.com>
>  Date            : 2008-04-02 00:28 (6 days old)
>  References      : http://lkml.org/lkml/2008/4/1/408
>  Handled-By      : Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
>  Patch           : http://marc.info/?l=linux-netdev&amp;m=120756760521961&amp;w=2

This one is very difficult to verify. It happened exactly once in
 now 20 days... I'll be away from the box until the weekend,
 when I'll compile whatever kernel-of-the-day with Ilpo's fix
 on top, if it isn't in mainline by then, and... well, keep the
 torrents alive with an eye on the kernel logs.

Not sure what's the best thing to do with such a hard to
 reproduce issue. Perhaps marking it fixed by Ilpo's patch,
 and if it pops up again file a new bug linking it to the entry
 in bugzilla ?

--alessandro

 "Hold back the years, hold back the hours
 I want to live to see the sun break through these days"

 (Patrick Wolf, 'This Weather')
