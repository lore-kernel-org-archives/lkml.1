Return-Path: <linux-kernel-owner+w=401wt.eu-S965330AbXCBJkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330AbXCBJkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965347AbXCBJkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:40:32 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:37593 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965330AbXCBJkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:40:31 -0500
Message-ID: <45E7F13E.60408@drzeus.cx>
Date: Fri, 02 Mar 2007 10:41:18 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Werner LEMBERG <wl@gnu.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Memory stick reader Ricoh R5C592 supported?
References: <20070302.102351.146595518.wl@gnu.org>
In-Reply-To: <20070302.102351.146595518.wl@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Werner LEMBERG wrote:
> Folks,
> 
> 
> my Dell Inspiron 6400 laptop has both a Ricoh R5C822 host adapter (for
> SD, MMC, etc.) and a Ricoh R5C592 host adapter for memory sticks.
> 
> While the former works just fine, it seems to me that the latter
> hasn't any support.  Indeed, inserting a Sony MSA-128A memory stick
> causes no reaction whatsoever.  Searching with google, I haven't found
> anything related to this chip; looking into the kernel source code
> wasn't successful either.
> 
> Can you please shed some light on the current situation?  I'm using
> kernel 2.6.20.
> 

Memory stick is completely unsupported. We haven't got any specs for neither the
the host controllers or the protocol. So I would guess it would be quite some
time before memorystick is supported directly by Linux.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
