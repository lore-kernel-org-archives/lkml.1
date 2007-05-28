Return-Path: <linux-kernel-owner+w=401wt.eu-S1761584AbXE1Xtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761584AbXE1Xtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 19:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbXE1XtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 19:49:25 -0400
Received: from keil-draco.com ([216.193.185.50]:50808 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758594AbXE1XtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 19:49:24 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: stuff ready to be deleted?
Date: Mon, 28 May 2007 19:49:20 -0400
User-Agent: KMail/1.9.6
Cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain> <6101e8c40705281344u7159e497rb4d001eba1d739cd@mail.gmail.com> <Pine.LNX.4.64.0705281651030.15906@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705281651030.15906@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281949.20783.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 16:52:07 Robert P. J. Day wrote:
> On Mon, 28 May 2007, Oliver Pinter wrote:
> > + open sound system
>
> yeah, that one's so obvious, i don't even list it anymore. :-)  i'm
> assuming adrian's going to deal with that when the time comes.
>
> rday

And I thought OSS was being kept around until all the hardware it drives 
properly is also supported by ALSA. Last time this one came up there were 
still more than 5 items on the list of OSS supported hardware that wasn't 
covered under ALSA - and the list was likely longer.

DRH
