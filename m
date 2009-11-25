Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZKYSTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZKYSTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbZKYSTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:19:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41168 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862AbZKYSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:19:18 -0500
Subject: Re: [PATCHv2 1/3] twl4030-regulator: Add all TWL regulators to
 twreg_info
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <1259158963.6303.5.camel@keskisaa-workstation>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259143495-9480-2-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <1259156290.6303.2.camel@keskisaa-workstation>
	 <1259156960.3697.74.camel@odin>
	 <1259158963.6303.5.camel@keskisaa-workstation>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 18:19:22 +0000
Message-ID: <1259173162.3697.91.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 16:22 +0200, Juha Keski-Saari wrote:
> On Wed, 2009-11-25 at 14:49 +0100, ext Liam Girdwood wrote:
> > On Wed, 2009-11-25 at 15:38 +0200, Juha Keski-Saari wrote:
> > > Regrettably it seems I slipped a mistake into this patch which took out
> > > the regulators VAUX1-3. Below is a version which removes this issue
> > > 
> > 
> > Ah, I've just applied and pushed this series. Can you redo against
> > voltage for-next ?
> > 
> > Thanks
> > 
> > Liam
> 
> Here are the additions done on recent voltage-2.6/for-next, my apologies
> for the extra work
> 
> >From 03578bd4f927f7777557be6d473eb0011b80608a Mon Sep 17 00:00:00 2001
> From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
> Date: Wed, 25 Nov 2009 16:18:35 +0200
> Subject: [PATCH] twl4030-regulator: Fixes VAUX1-3 exclusion introduced
> in 3277b9fce0fcaa68d5947429e062163852ebc6fb
> 
> Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
> ---
>  drivers/regulator/twl4030-regulator.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

