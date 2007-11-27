Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbXK0NUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbXK0NUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbXK0NUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:20:04 -0500
Received: from eazy.amigager.de ([213.239.192.238]:38145 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbXK0NUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:20:03 -0500
Date: Tue, 27 Nov 2007 14:20:00 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: XFS related Oops (suspend/resume related)
Message-ID: <20071127132000.GA31893@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20071112064706.GA23595@dose.home.local> <20071126131210.GA4430@eazy.amigager.de> <20071126210844.GB119954183@sgi.com> <200711262307.56742.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711262307.56742.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 23:07:56 +0100, Rafael J. Wysocki wrote:

[...]

> On 2.6.23.1 you can test the freezer alone by doing
> 
> # echo testproc > /sys/power/disk
> # echo disk > /sys/power/state

This is suspend to RAM, not to disk.

Regards,
Tino
