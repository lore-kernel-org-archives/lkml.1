Return-Path: <linux-kernel-owner+w=401wt.eu-S1751679AbZK0N2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbZK0N2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZK0N2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:28:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42265 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751286AbZK0N2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:28:07 -0500
Date: Fri, 27 Nov 2009 13:28:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "A. Porodko" <panda@chelcom.ru>
Cc: Chaithrika U S <chaithrika@ti.com>,
       "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Jaroslav Kysela'" <perex@perex.cz>, "'Takashi Iwai'" <tiwai@suse.de>,
       "'Troy Kisky'" <troy.kisky@boundarydevices.com>,
       "'David Brownell'" <dbrownell@users.sourceforge.net>,
       "'Kevin Hilman'" <khilman@deeprootsystems.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] Sound support for Neuros OSD2 Davinci based board.
Message-ID: <20091127132811.GA17711@rakim.wolfsonmicro.main>
References: <4B0E7D5E.3080906@chelcom.ru>
 <002e01ca6e9c$2dab6040$890220c0$@com>
 <20091127111254.GB29512@sirena.org.uk>
 <4B0FD0B2.9070303@chelcom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0FD0B2.9070303@chelcom.ru>
X-Cookie: Yow!  Are we laid back yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 06:14:26PM +0500, A. Porodko wrote:
> Mark Brown wrote:

> > I raised the same query when Andrey sent an off-list copy to me by
> > mistake - he said that in future he intends to extend the driver to 
> > have additional features not present on the EVM (though for me that
> > could always change the || later).

> Understood. Shall I change if if to if || then?

Honestly I'm not that bothered, I was mostly following up to the list so
that readers and the archives could see the answer to the query (I
guessed you may have mistakenly replied off list).
