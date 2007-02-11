Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXBKWvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXBKWvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932761AbXBKWvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:51:49 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:31547 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbXBKWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:47 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
Subject: Re: Problem with USB ports and a dongle
Date: Sun, 11 Feb 2007 23:51:53 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, alex14641@yahoo.com
References: <45CF87EE.5000401@wanadoo.fr>
In-Reply-To: <45CF87EE.5000401@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702112351.53504.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH7ISOhOtBs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. Februar 2007 22:17 schrieb Thibaud Hulin:
> Hi !
> 
> I'm trying to use a dongle for ndiswrapper, but it fails because a 
> problem of usb. Note that the problem appear when ndiswrapper is fully 
> uninstalled (and others packages as ndiswrapper-utils, with modprobe -r, 
> etc...).

This report is valid only if ndiswrapper was never loaded from booting
to the error. Please post the report to linux-usb-devel@lists.sourceforge.net
and recompile your kernel with CONFIG_USB_DEBUG.

	HTH
		Oliver
