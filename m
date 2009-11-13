Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZKMSxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZKMSxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZKMSxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:53:38 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:52902 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbZKMSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:53:38 -0500
MIME-Version: 1.0
In-Reply-To: <1258108877-25435-1-git-send-email-l.fu@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de> 
	<1258108877-25435-1-git-send-email-l.fu@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 13 Nov 2009 11:53:23 -0700
X-Google-Sender-Auth: a41bc11ab3bbc030
Message-ID: <fa686aa40911131053xec0774ey33e451b6233ff6c4@mail.gmail.com>
Subject: Re: [V2] Patches for mpc52xx_spi
To: Luotao Fu <l.fu@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 3:41 AM, Luotao Fu <l.fu@pengutronix.de> wrote:
>
> Hi Grand,
>
> here are the V2 of my patchset for mpc52xx_spi. Besides Wolframs suggestions I
> also added some more fixes. Details of changes can be checked in the patch
> header. Please do consider to apply the patches. The patch 1/2 e.g. fix bugs,
> which prevent the driver to work in some cases, as seen on my board.

Applied to my 'test' branch on git.secretlab.ca

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
