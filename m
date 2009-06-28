Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZF1GgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZF1GgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 02:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbZF1GgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 02:36:09 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:64492 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbZF1GgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 02:36:08 -0400
From: Frans Pop <elendil@planet.nl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [regression] drm: display arifacts when X.Org is stopped
Date: Sun, 28 Jun 2009 08:36:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
References: <200906271852.57388.elendil@planet.nl> <21d7e9970906271844t15540ef8x57df641e87ab71fc@mail.gmail.com>
In-Reply-To: <21d7e9970906271844t15540ef8x57df641e87ab71fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906280836.09142.elendil@planet.nl>
X-OriginalArrivalTime: 28 Jun 2009 06:36:09.0932 (UTC) FILETIME=[B92A88C0:01C9F7BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009, Dave Airlie wrote:
> On Sun, Jun 28, 2009 at 2:52 AM, Frans Pop<elendil@planet.nl> wrote:
> > With 2.6.31-rc1 I'm getting fairly serious display artifacts when
> > X.Org is stopped and the display switches modes. This happens when I
> > reboot the system (on the switch back to VT1), but also when I just
> > restart the X server from the kdm splash screen.
> >
> > My text consoles use the VESA framebuffer (vga=791).
> > I'm not using GEM.
>
> you can't not use GEM, you can not use kernel modesetting which is
> what I assume you are saying.

Yes, sorry.

> Have you 4GB RAM btw?

No, just 2GB.
