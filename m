Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZFHJ6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZFHJ6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZFHJ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:57:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:47083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbZFHJ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:57:55 -0400
Date: Mon, 8 Jun 2009 11:57:57 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: fix missing space typo in doc
In-Reply-To: <4A2AA21C.4020401@freemail.hu>
Message-ID: <alpine.LNX.2.00.0906081157350.7457@wotan.suse.de>
References: <4A2AA21C.4020401@freemail.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-123415590-1244455077=:7457"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-123415590-1244455077=:7457
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 6 Jun 2009, Németh Márton wrote:

> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.30-rc7/Documentation/usb/callbacks.txt.orig	2009-03-24 00:12:14.000000000 +0100
> +++ linux-2.6.30-rc7/Documentation/usb/callbacks.txt	2009-06-03 19:51:07.000000000 +0200
> @@ -65,7 +65,7 @@ Accept or decline an interface. If you a
>  otherwise -ENODEV or -ENXIO. Other error codes should be used only if a
>  genuine error occurred during initialisation which prevented a driver
>  from accepting a device that would else have been accepted.
> -You are strongly encouraged to use usbcore'sfacility,
> +You are strongly encouraged to use usbcore's facility,
>  usb_set_intfdata(), to associate a data structure with an interface, so
>  that you know which internal state and identity you associate with a
>  particular interface. The device will not be suspended and you may do IO

Applied to trivial tree, thanks.

-- 
Jiri Kosina
SUSE Labs

--168427776-123415590-1244455077=:7457--
