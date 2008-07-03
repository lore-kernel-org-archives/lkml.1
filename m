Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYGCPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYGCPxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYGCPxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:53:05 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:48475 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYGCPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:53:03 -0400
Date: Thu, 03 Jul 2008 08:53:00 -0700
From: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26,
	prevents use of device
In-reply-to: <200807031005.59691.oliver@neukum.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org
Message-id: <1215100380.6054.210.camel@lenovo.local.net>
Organization: Mandriva
MIME-version: 1.0
X-Mailer: Evolution 2.22.2-3mdv2009.0
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
 <200807022333.25275.oliver@neukum.org>
 <1215034900.6054.204.camel@lenovo.local.net>
 <200807031005.59691.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 10:05 +0200, Oliver Neukum wrote:
> Am Mittwoch 02 Juli 2008 23:41:40 schrieb Adam Williamson:
> > On Wed, 2008-07-02 at 23:33 +0200, Oliver Neukum wrote:
> > 
> > > This is odd. Your device shows one interface with one endpoint bulk and
> > > bulk out respectively. Yet two ports are created. Odd.
> > 
> > OK. If you mean /dev/ttyUSB0 and /dev/ttyUSB1 are always both created
> > when the device is plugged in - yep. This is the case in the working
> 
> Now this is very hard to explain. From the code in 2.6.25 it is clear that
> only ttyUSB0 will be created. Please verify that indeed you get ttyUSB0
> and ttyUSB1 with the kernel working for you.

It is possible I'm misremembering on that front. I will check.
-- 
adamw

