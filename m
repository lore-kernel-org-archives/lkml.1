Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZHTHdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZHTHdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZHTHdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:33:51 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54851 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZHTHdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DFUvOO6/7W7fEcwkhG3L4kTdMBVyGiGipq5yVaFWw/a7Qeod6v8m3rc6LB9NplqJ5G
         OV6L1u17/TqYjX88FCbHKovqmT77uou7fh+T1TxeK16pE+aHoF1a7hv3ro+rGDRyKp6J
         uAzDR6ZiNk9y44xbPXLXYFrw50oQm22Od1tic=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <ADSuNT6McuD.A.R0.COIjKB@chimera>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	 <ADSuNT6McuD.A.R0.COIjKB@chimera>
Date: Thu, 20 Aug 2009 10:33:50 +0300
X-Google-Sender-Auth: da20ee1fc19a343d
Message-ID: <11fae7c70908200033k7c28561eh28e1195ce4a692f8@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it's still valid.

Screenshots of the crash have been provided. Is anything else missing
for the LKML to be able to debug and fix this?

On Wed, Aug 19, 2009 at 11:26 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13941
> Subject         : x86 Geode issue
> Submitter       : Martin-Éric Racine <q-funk@iki.fi>
> Date            : 2009-08-03 12:58 (17 days old)
> References      : http://marc.info/?l=linux-kernel&m=124930434732481&w=4
>
>
>
