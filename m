Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbYDUNkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbYDUNkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYDUNkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:40:09 -0400
Received: from styx.suse.cz ([82.119.242.94]:52203 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755891AbYDUNkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:40:07 -0400
Date: Mon, 21 Apr 2008 15:40:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 29/37] Input: fix ordering in joystick Makefile
In-Reply-To: <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com>
Message-ID: <Pine.LNX.4.64.0804211532090.12972@jikos.suse.cz>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
 <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Jiri Kosina wrote:

> Make entries in drivers/input/joystick/Makefile properly alphabetically
> ordered.
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Hi Dmitry,

this patch of mine assumed that the driver for SEGA Dreamcast controller 
[1] is merged, but it doesn't seem to be present in the lineup you have 
sent ... ?

Thanks,

[1] 
ftp://ftp.kernel.org/pub/linux/kernel/people/jikos/temporary-input-queue/upstream/0013-Input-maple-add-driver-for-Sega-Dreamcast-controll.patch

-- 
Jiri Kosina
SUSE Labs
