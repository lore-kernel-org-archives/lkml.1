Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZH3M7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZH3M7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 08:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZH3M7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 08:59:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41853 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZH3M63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 08:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=BeKoKzze6s2PpM9ECMgtZtzzIePKjzerrXr09e0B3TFR6J6GijZKqyPunGJpJig3LI
         wgysEUi9f2zCtV8sD3YjiaZp0AZKHlydAnjVel3f25kQKxTlrt6xL2NZEPXChQysmLWa
         5ut+whnG18zBLmqpn62NpJtxN7FW0BUjbUmuo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/33] Staging: rt{286,287,307}0: merge rt3070 with rt2870
Date: Sun, 30 Aug 2009 14:28:34 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain> <1251093268.7549.3.camel@marge.simson.net>
In-Reply-To: <1251093268.7549.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908301428.35020.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 August 2009 07:54:28 Mike Galbraith wrote:
> On Sun, 2009-08-23 at 15:28 +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> > I tested it on RT2860 and RT3070 chipsets already but I would need some help
> > from people with RT2870 hardware to verify those changes (Mike? Marcin?).
> 
> I gave it a spin over java this morning, works fine here.  This message
> brought to you by my 2870.

Thanks!

I'll keep you guys in the loop for the future changes as well. ;)
