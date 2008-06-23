Return-Path: <linux-kernel-owner+w=401wt.eu-S1763327AbYFWTcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763327AbYFWTcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763251AbYFWTce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:32:34 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9108 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763237AbYFWTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:32:33 -0400
Date: Mon, 23 Jun 2008 12:31:16 -0700
From: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26,
	prevents use of device
In-reply-to: <200806232041.09251.oliver@neukum.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
Message-id: <1214249476.6054.21.camel@lenovo.local.net>
Organization: Mandriva
MIME-version: 1.0
X-Mailer: Evolution 2.22.2-3mdv2009.0
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
 <200806230948.03027.oliver@neukum.org>
 <1214236003.6054.6.camel@lenovo.local.net>
 <200806232041.09251.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 20:41 +0200, Oliver Neukum wrote:
> Am Montag 23 Juni 2008 17:46:43 schrieb Adam Williamson:
> > On Mon, 2008-06-23 at 09:48 +0200, Oliver Neukum wrote:
> > > Am Montag 23 Juni 2008 00:37:20 schrieb Alan Cox:
> > > > > > btw this also shows that this isn't a 2.6.25 regression... 
> > > > > 
> > > > > That hardly shows it.
> > > > > 
> > > > > And Adam said quite explicitely that 2.6.25 worked for him.
> > > > 
> > > > Nothing much I can do to help. The URB is assigned in setup and is NULL
> > > > later. Nothing else I can find touches it.
> > > 
> > > We need this oops replicated with debug enabled in the usb serial core.
> > 
> > Is that just a kernel build option? (As I mentioned earlier, I'm not
> > much of a kernel hacker, I usually just run packaged kernels).
> 
> It is the module option "debug" for usb-serial.

Oh, that's easy then. :) Will do that later. Thanks.
-- 
adamw

