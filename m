Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZFFHwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZFFHwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZFFHwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:52:01 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55523 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZFFHwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fH1t1RPh/Y7fsZCSNUfSSqqYvQsutZFAZeTB9PRQ4fp2PgyJArWb+yzFMJ6UhOPhkl
         kExrywbQbyCabFcG55jkwBsWFqLEKi6Iu3GF/FVjQnTOMgPuUWqWkcHtT2bB3Es1tL31
         zpJ06XSOVt0JIrjKpone5M2FxaqsECdKzRL3g=
MIME-Version: 1.0
In-Reply-To: <20090606003159.114c2fab.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <20090605130835.e21eaf37.akpm@linux-foundation.org>
	 <71cd59b00906060025w66d770f7he34f9172cd720c8c@mail.gmail.com>
	 <20090606003159.114c2fab.akpm@linux-foundation.org>
Date: Sat, 6 Jun 2009 09:52:00 +0200
Message-ID: <71cd59b00906060052n153835e8p37e0ccb7c73ba5c5@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Corentin Chary <corentin.chary@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 6, 2009 at 9:31 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Sat, 6 Jun 2009 09:25:34 +0200 Corentin Chary <corentin.chary@gmail.com> wrote:
>
>> fixed patch pushed into acpi4asus.
>
> What's that?
>
> Should it be added to linux-next?
>

http://acpi4asus.sourceforge.net/ -
http://git.iksaif.net/?p=acpi4asus.git;a=summary
The tree is based on
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6

It's where I regroup eeepc/asus patchs before sending them to Len.

I don't think it should be added to linux-next, because the patchs
will first go into the acpi tree, wich is in linux-next.

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
