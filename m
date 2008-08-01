Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYHAMLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYHAMLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYHAMLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:11:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYHAMK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:10:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yudha Harimantoro T" <yudha.ht@gmail.com>
Subject: Re: Error on Make Modules [2.6.27-rc1]
Date: Fri, 1 Aug 2008 14:13:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com>
In-Reply-To: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808011413.29388.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of August 2008, Yudha Harimantoro T wrote:
> Hi,
> I make with 2.6.27-rc1 with my oldconfig.
> 
> I build the kernel and there's error on modules.
> Errors :
> -----------------------------------------------------------------------
> root@system:/usr/src/linux# make
> ...................
> ...................
> CC      net/xfrm/xfrm_ipcomp.mod.ko
> LD [M] net/xfrm/xfrm_ipcomp.ko
> make[1]: Nothing to be done for `__fw_modbuild'.
> root@system:/usr/src/linux# make modules
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   Building modules, stage 2.
>   MODPOST 545 modules
> make[1]: Nothing to be done for `__fw_modbuild'.
> root@system:/usr/src/linux#
> -----------------------------------------------------------------------

Hm, there are no any errors here as far as I can see.

Thanks,
Rafael
