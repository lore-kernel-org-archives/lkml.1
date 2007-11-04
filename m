Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbXKDKi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbXKDKi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 05:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbXKDKiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 05:38:18 -0500
Received: from smtpout.hostsharing.net ([83.223.95.15]:56817 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbXKDKiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 05:38:17 -0500
Date: Sun, 4 Nov 2007 11:38:09 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Nathan Lynch <ntl@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
Message-ID: <20071104103809.GA2788@aragorn.home.lxtec.de>
Mail-Followup-To: Nathan Lynch <ntl@pobox.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linuxppc-dev@ozlabs.org
References: <20071024120739.GA4897@aragorn.home.lxtec.de> <20071024124109.GA9442@frodo.home.lxtec.de> <20071104032006.GG9695@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
In-Reply-To: <20071104032006.GG9695@localdomain>
Organization: LXTEC
X-gnupg-key-fingerprint: BE65 85E4 4867 7E9B 1F2A  B2CE DC88 3C6E C54F 7FB0
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled Oct 20 2007 16:24:45)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Nov 2007 the mental interface of
Nathan Lynch told:

> (cc'ing linuxppc-dev, see
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg221770.html
> for original post and .config)
[...]
> > console handover: boot [udbg0] -> real [tty0]
> 
> Does 2.6.23 (or any earlier kernel) work?
The powerbook runs Linux since 2.6.12. The config is generated
always by make oldconfig and checking new options for meaningful
use. If I have time, I test rc versions.

Thanks for cooperation :)

Elimar

-- 
  Experience is something you don't get until 
  just after you need it!
