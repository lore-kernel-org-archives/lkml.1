Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0BEP5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:57:19 -0500
Received: from 78-33-71-188.static.enta.net ([78.33.71.188]:62359 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752112Ab0BEP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:57:18 -0500
X-Greylist: delayed 4478 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 10:57:18 EST
Date: Fri, 5 Feb 2010 14:39:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>, Vikram Pandita <vikram.pandita@ti.com>,
       Christian Pellegrin <chripell@fsfe.org>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete config in kernel source (HARD_PPS)
Message-ID: <20100205143937.5081eacb@lxorguk.ukuu.org.uk>
In-Reply-To: <20100205134718.GC7077@faui49.informatik.uni-erlangen.de>
References: <20100205134718.GC7077@faui49.informatik.uni-erlangen.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	There are a bunch of files in the current linux tree checking
> for CONFIG_HARD_PPS which isn't in KConfig neither any other media of
> setting it as far as I can tell and has been like this for ages.

HARD_PPS isn't yet upstream but having the hooks there is useful in the
meantime
