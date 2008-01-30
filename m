Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbYA3HxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbYA3HxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYA3Hwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:52:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:40982 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYA3Hwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:52:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TaZSegZXwYHg941DyV8DPiTPD0c71UeiElKpfYGZ5feBia4JkbfsGQvmsLCdllV5ZiUaudLH6AhHW6CePkEbGZnGklXYHSP1v2PXTOZGSerRNbeQjUBFj7ZdhDCciaEq7RpWjLRNEPSjQJm8uIpeaVwszcXTX90vw0wuElTsZo0=
Message-ID: <84144f020801292352m13d34f36i3f4d930534ffa805@mail.gmail.com>
Date: Wed, 30 Jan 2008 09:52:50 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "CooperYuan Cooper" <cooperyuan@gmail.com>
Subject: Re: About closed-source module use GPL module function
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a9cbba340801292241y1e5e553dnbcb6734e57935832@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9cbba340801292241y1e5e553dnbcb6734e57935832@mail.gmail.com>
X-Google-Sender-Auth: 5f941b614bc8a28f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 30, 2008 8:41 AM, CooperYuan Cooper <cooperyuan@gmail.com> wrote:
> Now I am porting a device driver to Linux, its source code is not opened.
>
> In this module, I use some interface functions exported from GPL
> module through EXPORT_SYMBOL macros. (not EXPORT_SYMBOL_GPL), For
> example, register_sound_dsp() and so on.
>
> Do I violate GPL? How to solve it?

This list is probably a not good source for (free) legal advice but
the simplest way to be sure is to release the source code under GPLv2.
HTH.

                        Pekka
