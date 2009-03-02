Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZCBPfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZCBPfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZCBPfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:35:03 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:45833 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZCBPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:35:02 -0500
Date: Mon, 2 Mar 2009 15:34:58 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Oguz Yarimtepe <comp.ogz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usb hotplug and hooking
Message-ID: <20090302153458.GA25965@silver.sucs.org>
References: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 02, 2009 at 03:39:41PM +0200, Oguz Yarimtepe wrote:
> I want to run an application when an external usb flash disk is plugged to
> my box machine that has STLinux installed in it. My aim is to check some
> issues on usb disk, whether it has an official software or not. I am not
> sure how will i hook my own application that will check usb device
> when it is plugged. I don't want the application run at the
> background, but run only when a plug is occured.

I think these days that problem tends to be handled by HAL
http://www.freedesktop.org/wiki/Software/hal and some software listening
to HAL events on dbus . If you are using KDE or GNOME both of these have
tools for automatically running software when devices are detected
(GNOME uses gnome-volume-manager and I think KDE has media://ioslave).

-- 
Sitsofe | http://sucs.org/~sits/
