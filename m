Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbXEIPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbXEIPLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXEIPLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:11:05 -0400
Received: from www.osadl.org ([213.239.205.134]:35202 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751600AbXEIPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:11:03 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch] Add the device IDs for AMD/ATI SB700
Date: Wed, 9 May 2007 17:10:28 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, Henry Su <henry.su@amd.com>,
       alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       xiaosuzi520@hotmail.com
References: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com> <4641C066.8080100@garzik.org> <20070509142115.GA26646@kroah.com>
In-Reply-To: <20070509142115.GA26646@kroah.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091710.28332.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 09 Mai 2007 16:21 schrieb Greg KH:
> On Wed, May 09, 2007 at 08:36:54AM -0400, Jeff Garzik wrote:
> > Henry Su wrote:
> > > From: henry.su@amd.com
> > > Adding the device ID for AMD/ATI SB700.
> > > Signed-off-by:henry su <henry.su@amd.com>
> > 
> > Time to train new people...
> > 
> > You need to split up your patches:
> > * send I2C and PCI quirk patches to GregKH
> 
> Nope, I2C is not me anymore, I think it's already on it's third
> maintainer

AFAICT, Jean Delvare only dropped lm-sensors maintainership. He is
still maintainer (and hopefully stays) of the i2c subsystem.

Anyway, whoever maintains it, patches for i2c should be sent to
the i2c mailing list, i2c@lm-sensors.org

Hans
