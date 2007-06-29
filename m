Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXF2LHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXF2LHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbXF2LGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:06:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:5291 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737AbXF2LGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oxDuP9nYTmTL2obPGMRybvuIuMmyTyWzYWzDMZ2e59hwOv8C5SoqoUtP5L3SzgrO/L5JZDqlaza2ImQyuLlskyopYk4SRnpnlUzmPAdZYzyIlQoMSRZoya0W9hazrY//TS2kcXr+V/4tsNuDbYYRitKk6KPsZMqn+5HIzxJXHPw=
Message-ID: <4dde4acb0706290406v204fb87eif0e5fbae17636593@mail.gmail.com>
Date: Fri, 29 Jun 2007 16:36:50 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: Fwd: Mounting MMC card
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4684E65F.2070202@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <200706291038.58358.hjk@linutronix.de>
	 <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>
	 <4684CDCC.9030202@drzeus.cx>
	 <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
	 <4684D358.9090402@drzeus.cx>
	 <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
	 <4684DEF3.5060103@drzeus.cx>
	 <4dde4acb0706290357x54d3ea32vaf75d5cfe638cb25@mail.gmail.com>
	 <4684E65F.2070202@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Not likely. It's probably a no-op when you don't have devfs.
>

   CONFIG_MMC_DEBUG is already enabled. This is not printing any debug
statements as such.

Midhun.
