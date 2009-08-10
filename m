Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbZHJGzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbZHJGzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZHJGzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:55:44 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59093 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZHJGzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vglZT4a7WPk1lS2KBpiB+0IqF1ckUP8BdGurE/bGpLFup7oc/utC/gckFk/RYpvTLR
         eMlxeQNjf3IwKzDon9VGbusByJG5dait8emRiVVZPJn+3vBS80lx9usCP+Z4iSkb/0yo
         cgmBSExOy7UWe0lWmLUKEJShbtj6/Hp0XwHfY=
MIME-Version: 1.0
In-Reply-To: <u1L1PAbl8zG.A.-3C.bj1fKB@chimera>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
	 <u1L1PAbl8zG.A.-3C.bj1fKB@chimera>
Date: Mon, 10 Aug 2009 08:55:42 +0200
Message-ID: <b637ec0b0908092355w12547d8kf0207c24c833f93e@mail.gmail.com>
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

It happened only once so it's hard to tell. I'm going to test -rc6
when it comes out and report back.

Regards,
Fabio



On Sun, Aug 9, 2009 at 11:10 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
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
> Date            : 2009-08-06 20:15 (4 days old)
> References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
>
>
