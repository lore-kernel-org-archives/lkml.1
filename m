Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbYF3NIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbYF3NIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYF3NIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:08:42 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34208 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYF3NIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:08:41 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Mon, 30 Jun 2008 15:09:07 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200806251741.23589.oliver@neukum.org> <1214594934.6054.117.camel@lenovo.local.net>
In-Reply-To: <1214594934.6054.117.camel@lenovo.local.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301509.09013.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 27 Juni 2008 21:28:54 schrieb Adam Williamson:
> On Wed, 2008-06-25 at 17:41 +0200, Oliver Neukum wrote:
> > Am Mittwoch 25 Juni 2008 04:05:13 schrieb Adam Williamson:
> > > On Mon, 2008-06-23 at 20:41 +0200, Oliver Neukum wrote:
> > > 
> > > > It is the module option "debug" for usb-serial.
> > > 
> > > OK, here you go:
> > 
> > Please also set the debug module parameter for the ipaq module.
> 
> OK.

Your device is considered to have two ports but not enough endpoints.
Please provide the output of "lsusb -v"

	Regards
		Oliver

