Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbXITOwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbXITOwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXITOvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:51:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:52136 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbXITOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NIJAV07GV9zzgdreYu1Uy/aRWmDsG46pdPVe7QgMyoX9t4qffvx8guj8aJUgwd1jSXHLa6wBc0RldtiJl88Kgs26TO9zW0AzEmV8f0yco9x420uzaby0abDmAQYSXpT26M1sbgO45HRFNMOPKg3lolZO6peuG+zTrA1GagbwwaA=
Message-ID: <b6a2187b0709200751j586aee93x3c2320141a392586@mail.gmail.com>
Date: Thu, 20 Sep 2007 22:51:52 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: ACPI video mode patch review
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709201635000.24429@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E9AD88.7070400@zytor.com>
	 <Pine.LNX.4.64.0709201617440.24429@twin.jikos.cz>
	 <b6a2187b0709200722q2755111brb8b7c3bdc71e2129@mail.gmail.com>
	 <Pine.LNX.4.64.0709201635000.24429@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Thu, 20 Sep 2007, Jeff Chua wrote:
>

> With current -git, I still get the same behavior as with
> previous 2.6.23-rcX kernels - i.e. after resume (with
> acpi_sleep=s3_bios,s3_mode), I get corrupted image resembling the BIOS
> POST graphics.
>
> Previous kernels (I am currently pretty sure that
> 15028aad00ddf241581fbe74a02ec89cbb28d35d was OK, but I haven't done the
> bisection yet) resumed perfectly with acpi_sleep=s3_bios,s3_mode on this
> machine.
>
> Please note that this is very different HW than you have - it is sort-of a
> desktop machine, not a notebook at all.

Sorry, with -rc7, still needs the patch. Apparently it's still not
included in the -rc7 kernel.

It might already be in the latest git, but just want to be sure that's the case.

Jeff.
