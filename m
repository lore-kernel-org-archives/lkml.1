Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYEYUPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYEYUPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYEYUO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:14:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:37256 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbYEYUO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f/EuzRqWTl6fmTnDyCHVvVRlw2422jcSypUGJzWGdcj1G6w24aCuvY3j6oTZ4081Tgjlf7474fbdNRiOeohTG5Zeu6kq5D8x93tTaITFEoUTS1ou/W1I4a7e+8b1tGOmkobJLkwfRxurNmYCZdKmquePyqW8CH4dU+ApE4C1P3Y=
Message-ID: <b6c5339f0805251314l5add3dcbi1232d48789c2229c@mail.gmail.com>
Date: Sun, 25 May 2008 16:14:56 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-rc3-git7: Reported regressions from 2.6.25
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>, jbarnes@virtuousgeek.org
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
X-Google-Sender-Auth: 4a83d2ecbd5687fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 4:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10628
> Subject         : 2.6.26-rc1-git1 -- trying to get vblank count for disabled pipe 0
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2008-05-04 21:12 (21 days old)
> References      : http://lkml.org/lkml/2008/5/4/309
> Handled-By      : Jesse Barnes <jbarnes@virtuousgeek.org>

(CCed Jesse)

This one was fixed for me by af6061af0d9f84a4665f88186dc1ff9e4fb78330,
'Revert "drm/vbl rework: rework how the drm deals with vblank."'

-- 
Bob Copeland %% www.bobcopeland.com
