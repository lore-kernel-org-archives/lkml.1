Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZHZGj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZHZGj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZHZGj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:39:57 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50578 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZHZGj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bl4zyR5rEO44ospw/8Zc4+9VytgW7DWoSH6nXK+ivE3jM8SA8PgTE52D7gO7OPdfwn
         sixuOJ+XrS/asDk96Kk2Oz3pwaMl7UdLYE/AA1bzZm9uGDDkjpVoWy2DZlRpiSY43vBP
         BDOq36XuUL1dka2MhnjvGRvaPxA1nyqtYIUfw=
MIME-Version: 1.0
In-Reply-To: <_yaHeGjHEzG.A.YH.TtGlKB@chimera>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <_yaHeGjHEzG.A.YH.TtGlKB@chimera>
Date: Wed, 26 Aug 2009 08:39:55 +0200
Message-ID: <b637ec0b0908252339u20b7b2c6od3601697cb7aee43@mail.gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still present as of -rc6-git7 (didn't try -rc7)

On Tue, Aug 25, 2009 at 10:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject         : WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-08-06 20:15 (20 days old)
> References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
>
>
