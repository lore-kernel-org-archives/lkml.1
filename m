Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXKSF5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXKSF5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 00:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXKSF5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 00:57:13 -0500
Received: from [212.12.190.47] ([212.12.190.47]:41915 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbXKSF5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 00:57:12 -0500
From: Al Boldi <a1426z@gawab.com>
To: viro@ftp.linux.org.uk
Subject: Re: [PATCH][retry-2] init: Introduce rootdir bootparm to select which dir to sys_chroot
Date: Mon, 19 Nov 2007 08:56:54 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, akpm@linux-foundation.org
References: <200711182009.19072.a1426z@gawab.com> <20071118212215.002fcd8b@laptopd505.fenrus.org>
In-Reply-To: <20071118212215.002fcd8b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711190856.54822.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> to be honest, this is something that really should be done in the
> initramfs image; we should strive to keep the more complex bootup
> scenarios there and not inside the kernel bootup code...

Agreed, but this is neither complex nor is it a scenario.

This is a shortcut.  And, IMHO, a clean one.


Thanks!

--
Al

