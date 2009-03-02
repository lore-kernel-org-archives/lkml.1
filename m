Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZCBOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZCBOIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZCBOI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:08:29 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46445 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZCBOI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:08:28 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Oguz Yarimtepe <comp.ogz@gmail.com>
Subject: Re: usb hotplug and hooking
Date: Mon, 2 Mar 2009 15:13:00 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
In-Reply-To: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-9"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903021513.01356.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 02 März 2009 14:39:41 schrieb Oguz Yarimtepe:
> Hi,
>
> I want to run an application when an external usb flash disk is plugged to
> my box machine that has STLinux installed in it. My aim is to check some
> issues on usb disk, whether it has an official software or not. I am not
> sure how will i hook my own application that will check usb device
> when it is plugged. I don't want the application run at the
> background, but run only when a plug is occured.

Have you looked at writing a udev script? Do you need a GUI?

	Regards
		Oliver

