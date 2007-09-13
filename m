Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbXIMJuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbXIMJuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXIMJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:50:29 -0400
Received: from www.osadl.org ([213.239.205.134]:55351 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752383AbXIMJu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:50:28 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Fix a lock problem in generic phy code
Date: Thu, 13 Sep 2007 11:50:29 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       afleming@freescale.com
References: <200708311430.09590.hjk@linutronix.de> <46E8B8C4.5010203@garzik.org>
In-Reply-To: <46E8B8C4.5010203@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709131150.30609.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 13 September 2007 schrieb Jeff Garzik:
> Hans-Jürgen Koch wrote:
> > Lock debugging finds a problem in phy.c and phy_device.c,
> > this patch fixes it. Tested on an AT91SAM9263-EK board,
> > kernel 2.6.23-rc4.
> >
> > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
>
> applied

Thanks! Andrew applied it to -mm, too.

Hans

