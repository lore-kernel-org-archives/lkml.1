Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXJLLyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXJLLyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 07:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXJLLyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 07:54:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbXJLLyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 07:54:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>, Michael Leun <ml@newton.leun.net>
Subject: Re: solved: 2.6.23 && fglrx && s2ram
Date: Fri, 12 Oct 2007 14:10:10 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071012000722.3cbf17b6@elektra.leun.net> <20071012014907.0005aab7@elektra.leun.net> <20071012000634.GC3620@stusta.de>
In-Reply-To: <20071012000634.GC3620@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710121410.11050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 October 2007 02:06, Adrian Bunk wrote:
> On Fri, Oct 12, 2007 at 01:49:07AM +0200, Michael Leun wrote:
> > On Fri, 12 Oct 2007 01:31:17 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Hi,
> > > 
> > > On Friday, 12 October 2007 00:07, Michael Leun wrote:
> > > > Hello,
> > > > 
> > > > (please, don't blame me for using the binary only driver, I will
> > > > happily switch to a open source one once it properly runs mplayer,
> > > > e.g.).
> > > > 
> > > > Renaming the config options for suspend/sleep broke fglrx power
> > > > management.
> > > 
> > > It looks like your patch is against the fglrx driver, isn't it?
> > 
> > It is - I should have mentioned that, sorry.
> 
> This makes it 100% off-topic for linux-kernel - please send patches for 
> illegal modules to the vendors of these modules and not here.

Well, the information that it got broken by itself is valuable, so thanks for
it Michael, but the patch is certainly not interesting to us. :-)

Greetings,
Rafael
