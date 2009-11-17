Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZKQIGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZKQIGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZKQIGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:06:38 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:59767 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZKQIGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YMkqwiBkBigYP8fnowewWX2YmQupyZp5GQc4UKg51etvfHhnCHe9TeOwlMQB0MnZcx
         maOrbRz40iwooPCOtrrEIM61OwPZZS2UtbUYS3sjuheEtNstpqKNwA7bCpVBzTjWcKCh
         G8V8KaYJKnr9XSRAvsdS8Nm/FNDPxtpFBZj4Y=
MIME-Version: 1.0
In-Reply-To: <OWmO9uyC1hM.A.-xD.GqdALB@chimera>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	 <OWmO9uyC1hM.A.-xD.GqdALB@chimera>
Date: Tue, 17 Nov 2009 09:06:42 +0100
Message-ID: <b637ec0b0911170006j1b77b538na35923ab5855aa41@mail.gmail.com>
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

Still present last time I tried .31 series.

On Tue, Nov 17, 2009 at 12:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject         : WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-08-06 20:15 (103 days old)
> References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
>
>
