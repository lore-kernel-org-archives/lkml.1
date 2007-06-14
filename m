Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXFNMfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXFNMfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXFNMfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:35:20 -0400
Received: from styx.suse.cz ([82.119.242.94]:54183 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751491AbXFNMfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:35:18 -0400
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
From: Stanislav Brabec <sbrabec@suse.cz>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Hans de Goede <j.w.r.degoede@hhs.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070613103806.GF19888@suse.cz>
References: <466F1462.5090008@hhs.nl> <466F1E5C.5090002@zytor.com>
	 <20070613103806.GF19888@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Organization: SuSE CR, s. r. o.
Date: Thu, 14 Jun 2007 14:35:17 +0200
Message-Id: <1181824517.4530.8.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik wrote:

> > > The logo on the key is a homepage logo, the text below is www/homepage.
> > > So what to send? I believe that for consistency with the usb codes send
> > > it should be KEY_HOMEPAGE, but thats based on a sample of 1 usb
> > > keyboard. Input on what other usb keyboards send for the key with the
> > > homepage iocn is very much welcome.

It seems that several keyboards have both HomePage and WWW keys:

All these AT keyboards are from Xorg symbols/inet.

A4Tech Wireless Desktop 
BTC 9000A
Compaq Easy Access Keyboard
Compaq (eg. Armada, Evo) Laptop Keyboard
Logitech (common definition)
Logitech Internet Keyboard
Microsoft Office Keyboard

It would be nice if anybody can test similar AT/USB keyboard.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12                            tel: +420 284 028 966
190 00 Praha 9                                fax: +420 284 028 951
Czech Republic                                http://www.suse.cz/

