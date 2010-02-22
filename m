Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0BVKBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:01:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:55050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0BVKBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:01:36 -0500
Date: Mon, 22 Feb 2010 11:01:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: documentation additions and elimination of
 legacy filenames for Roccat Kone driver
In-Reply-To: <20100222062916.GA2095@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1002221100130.30967@pobox.suse.cz>
References: <201002200911.53900.stefan_achatz@web.de> <20100221081327.GB18298@core.coreip.homeip.net> <201002211750.45618.erazor_de@users.sourceforge.net> <20100222062916.GA2095@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Dmitry Torokhov wrote:

> On Sun, Feb 21, 2010 at 05:50:45PM +0100, Stefan Achatz wrote:
> >  This patch adds more documentation and renames sysfs attributes to eliminate my legacy naming.
> 
> There are still questions as to the intended use of the attributes...

Indeed.

Originally there was a plan to have everything under sysfs documented in 
Documentation/ABI.

Many developers (including me) have been too lazy to do that (or forgot to 
do so), but it might still be worthwile to resurrect this.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
