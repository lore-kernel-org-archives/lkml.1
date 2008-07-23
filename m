Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYGWEnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYGWEnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 00:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYGWEnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 00:43:05 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2547 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYGWEnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 00:43:04 -0400
Message-ID: <4886B69A.9090609@linuxtv.org>
Date: Wed, 23 Jul 2008 00:42:02 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>,
       Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/47] 2.6.25-stable review
References: <20080722231342.GA8282@suse.de>
In-Reply-To: <20080722231342.GA8282@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.25.12 release.
> There are 47 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> These patches are sent out with a number of different people on the
> Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> to add your name to the list.  If you want to be off the reviewer list,
> also email us.
>
> Responses should be made by July 24, 22:00:00 UTC.  Anything received
> after that time might be too late.
>   
Greg,

Would it be possible to add the seven patches that I sent two days ago? 
It is very important that patch #1 gets into the first dot release, to
avoid confusion with cx18 firmware revisions.  Thanks.

These were sent to stable at kernel dot org:

[2.6.26.y PATCH 1/7] V4L: cx18: Upgrade to newer firmware & update
documentation
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-July/007427.html

[2.6.26.y PATCH 2/7] DVB: dib0700: add support for Hauppauge Nova-TD
Stick 52009
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-July/007429.html

[2.6.26.y PATCH 3/7] V4L: uvcvideo: Fix a buffer overflow in format
descriptor parsing
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-July/007428.html

[2.6.26.y PATCH 4/7] V4L: uvcvideo: Use GFP_NOIO when allocating memory
during resume
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-July/007430.html

[2.6.26.y PATCH 5/7] V4L: uvcvideo: Don't free URB buffers on suspend
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-July/007431.html

[2.6.26.y PATCH 6/7] V4L: uvcvideo: Make input device support optional 
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-July/007432.html

[2.6.26.y PATCH 7/7] V4L: uvcvideo: Add support for Medion Akoya Mini
E1210 integrated webcam
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-July/007433.html

Regards,

Mike Krufky
