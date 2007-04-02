Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbXDBHEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbXDBHEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXDBHEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:04:43 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40446 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbXDBHEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:04:43 -0400
Date: Mon, 2 Apr 2007 09:04:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/16] vt-pure-colors.diff
In-Reply-To: <1175496592.4614.9.camel@daplas>
Message-ID: <Pine.LNX.4.61.0704020902200.1245@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr> <1175496592.4614.9.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 2 2007 14:49, Antonino A. Daplas wrote:
>
>Not too sure about this, the default palette is based on ANSI/ECMA
>standards (at least for the first 8 colors). Also, this will have subtle
>effects on the 16-color logo. Since your first patch already allows us
>to change the palette, let's leave the default alone.

Ok.
But to note: xterm and anything graphical (including MS Windows)
uses the anti-pale color (255,0,0) instead of (255,170,170).


Jan
-- 
