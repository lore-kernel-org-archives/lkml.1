Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZASX3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZASX3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZASX3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:29:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:39984 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753976AbZASX3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:29:42 -0500
Date: Tue, 20 Jan 2009 00:29:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, eric.piel@tremplin-utc.net
Subject: Re: lis3: fix documentation to fit into 80 columns
In-Reply-To: <20090114172013.GA25948@elf.ucw.cz>
Message-ID: <alpine.LNX.1.10.0901200027050.5377@jikos.suse.cz>
References: <20090114172013.GA25948@elf.ucw.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Pavel Machek wrote:

>  Sysfs attributes under /sys/devices/platform/lis3lv02d/:
>  position - 3D position that the accelerometer reports. Format: "(x,y,z)"
> -calibrate - read: values (x, y, z) that are used as the base for input class device operation.
> -            write: forces the base to be recalibrated with the current position.
> +calibrate - read: values (x, y, z) that are used as the base for input
> +		  class device operation.
> +            write: forces the base to be recalibrated with the current
> +		  position.

I don't seem to be able to figure out what indentation is being used here. 
Why two tabs and two spaces? It doesn't align with anything this way.

-- 
Jiri Kosina
