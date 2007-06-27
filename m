Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbXF0MI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbXF0MI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbXF0MIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:08:51 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:63098 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbXF0MIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:08:51 -0400
X-ME-UUID: 20070627120849195.2F9D11C00087@mwinf1911.orange.fr
Subject: Re: NVidia Driver Support - 1680x1050 mode
From: Xavier Bestel <xavier.bestel@free.fr>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Marc Perkel <mperkel@yahoo.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1090CBC0-91B3-49EC-9A69-4864201CA967@mac.com>
References: <6278d2220706270247k21ccdd24x41b84c631b05fcc0@mail.gmail.com>
	 <6278d2220706270249v410d7b8eyfca9873d55075c75@mail.gmail.com>
	 <1090CBC0-91B3-49EC-9A69-4864201CA967@mac.com>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 14:08:43 +0200
Message-Id: <1182946123.342.25.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 06:42 -0400, Kyle Moffett wrote:
> > If you're using a DVI cable, ensure it is dual-link.
> 
> Uhh, no;  1680x1050 does not require a dual-link DVI port/cable.

FWIW single-link DVI can do 1920x1200 - for that the X server uses a
"reduced blanking" mode, i.e. the vertical and horizontal retrace
intervals (useless for LCD/TFT anyway, there's no beam to move) are
shortened.

	Xav


