Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbYBMXiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbYBMXiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761231AbYBMXiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:38:02 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbYBMXh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:37:58 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: petkovbb@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Date: Thu, 14 Feb 2008 00:37:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
References: <200802121026.17420.hpj@urpla.net> <20080212172057.GA12480@gollum.tnic>
In-Reply-To: <20080212172057.GA12480@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140037.51450.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/49q7mPGLfUhdC3ylbLsdkg/+4V14uWhAlHTC
 9c9elyewlubWx4boYjr24+gfzAHYdxl/0rkjMWcjZV/SazQo5t
 uv8kP1E0PuOCxFptFShTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 12. Februar 2008 schrieb Borislav Petkov:
> On Tue, Feb 12, 2008 at 10:26:17AM +0100, Hans-Peter Jansen wrote:
> > Hi,
> >
> > I suffer from unreliable cdrom operations (failing DAE and burn
> > sessions) with the openSUSE 2.6.18.8-0.7-bigsmp kernel.
>
> 			^^^^
> Hi,
>
> can please you test this with a more recent kernel. Yours is almost
> ancient - from Sep. 2006.

Sure, sorry. Here we go:

Feb 14 00:18:18 kernel: hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
 Trying to recover by ending request.
Feb 14 00:27:27 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01). 
 Trying to recover by ending request.

~> uname -a
Linux xrated 2.6.24.1-35-pae #1 SMP 2008/02/12 01:00:18 UTC i686 athlon i386 GNU/Linux

Thanks for caring,
Pete
