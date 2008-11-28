Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYK1PnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYK1PnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 10:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYK1PnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 10:43:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYK1PnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 10:43:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Date: Fri, 28 Nov 2008 16:42:52 +0100
User-Agent: KMail/1.9.9
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com> <200811281243.02841.arnd@arndb.de> <20081128140335.GA21358@shell.devel.redhat.com>
In-Reply-To: <20081128140335.GA21358@shell.devel.redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811281642.52637.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/PQb223pl+wEMm7In6kxeLPh6d4LfyiMKx2EU
 Q1UO24PvkJxBP1l36GH21Z22NKRkQaAFyWCSWP50GkiZGFgUne
 HTnP8JRwxabx7LGuS6Ytw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2008, Alan Cox wrote:

> Removing it seems a bit pointless as someone will one day no doubt need
> to put it back again

Ok, so we should probably also have it in the new ->compat_ioctl call.

	Arnd <><


