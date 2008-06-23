Return-Path: <linux-kernel-owner+w=401wt.eu-S1762410AbYFWSkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762410AbYFWSkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYFWSko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:40:44 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46655 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYFWSkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:40:43 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Mon, 23 Jun 2008 20:41:07 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200806230948.03027.oliver@neukum.org> <1214236003.6054.6.camel@lenovo.local.net>
In-Reply-To: <1214236003.6054.6.camel@lenovo.local.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232041.09251.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 23 Juni 2008 17:46:43 schrieb Adam Williamson:
> On Mon, 2008-06-23 at 09:48 +0200, Oliver Neukum wrote:
> > Am Montag 23 Juni 2008 00:37:20 schrieb Alan Cox:
> > > > > btw this also shows that this isn't a 2.6.25 regression... 
> > > > 
> > > > That hardly shows it.
> > > > 
> > > > And Adam said quite explicitely that 2.6.25 worked for him.
> > > 
> > > Nothing much I can do to help. The URB is assigned in setup and is NULL
> > > later. Nothing else I can find touches it.
> > 
> > We need this oops replicated with debug enabled in the usb serial core.
> 
> Is that just a kernel build option? (As I mentioned earlier, I'm not
> much of a kernel hacker, I usually just run packaged kernels).

It is the module option "debug" for usb-serial.

	Regards
		Oliver

