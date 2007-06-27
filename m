Return-Path: <linux-kernel-owner+w=401wt.eu-S1761888AbXF0PQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761888AbXF0PQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXF0PQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:16:07 -0400
Received: from smtp24.orange.fr ([193.252.22.27]:53854 "EHLO smtp24.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXF0PQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:16:06 -0400
X-ME-UUID: 20070627151602881.D72441C0009D@mwinf2458.orange.fr
Subject: Re: NVidia Driver Support - 1680x1050 mode
From: Xavier Bestel <xavier.bestel@free.fr>
To: Marc Perkel <mperkel@yahoo.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <698083.6027.qm@web52505.mail.re2.yahoo.com>
References: <698083.6027.qm@web52505.mail.re2.yahoo.com>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 17:15:57 +0200
Message-Id: <1182957357.342.41.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 05:58 -0700, Marc Perkel wrote:
> Quite frankly, I don't understand why digital LCD
> monitor even have scan rates in the first place. It's
> not a CRT that actually has an electron beam. You
> would thing that it would have a digital interface
> where the computer told the monitor what to draw and
> the monitor deals with it.

That's it. Information is simply the content of the video RAM, given
serially at a certain rate (as the DVI interface is a serial interface
with a fixed rate, you can't redraw the display at 60fps above a certain
pixel quantity).

	Xav


