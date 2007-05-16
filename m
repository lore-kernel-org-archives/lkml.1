Return-Path: <linux-kernel-owner+w=401wt.eu-S1763088AbXEPRxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763088AbXEPRxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbXEPRx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:53:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:37842 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757445AbXEPRx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:53:29 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+22NAhbSi2XMAzVbUPSRexaPdVBR3Ol4yMEYYRdO
	4R+ea2DjcHfF1A
Date: Wed, 16 May 2007 19:53:25 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Pekka Pietikainen <pp@ee.oulu.fi>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Pekka Pietikainen goes UTF-8 (try #2)
Message-ID: <20070516175325.GA14519@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Pekka Pietikainen <pp@ee.oulu.fi>, "H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Adrian Bunk <bunk@stusta.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	trivial@kernel.org
References: <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr> <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr> <20070514202509.GA1515@stusta.de> <Pine.LNX.4.61.0705142235320.9570@yvahk01.tjqt.qr> <20070514204107.GB1515@stusta.de> <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr> <20070515162314.GA10965@ee.oulu.fi> <464A9F2E.5020801@zytor.com> <20070516163818.GA3834@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516163818.GA3834@ee.oulu.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.16 19:38:18 +0300, Pekka Pietikainen wrote:
> On Tue, May 15, 2007 at 11:05:34PM -0700, H. Peter Anvin wrote:
> > Pekka Pietikainen wrote:
> > > Since everyone else is doing it, why not me as well. Looks like I had
> > > a nice retro 7-bit a-umlaut in the tree from ten years ago too! 
> > > (That was back when ISO 8859-1 didn't work universally...).
> > > I hope my mailer is setup correctly for this, 
> > > http://www.ee.oulu.fi/~pp/pp-goes-utf8.patch has the same in 
> > > case something in the middle munges up the utf-8.
> > 
> > Your message came through tagged as iso-8859-1.
> I noticed. Reconfigured mutt, tested the change, then sent out the email
> >from an unrestarted mutt. Shame on me :-( .
> 
> I wonder how much hassle these kinds of patches will cause when the UTF-8
> chars they introduce start occasionally showing up in the diff -u context.
> Somehow I think the world might not be ready yet (maybe in 5 years or so
> I'll dare start using umlauts in email headers :D ). Oh well :-)
> 
> Since I'm polluting the list already, might as well take the opportunity
> to resubmit :)

Broken again :/

Since you're using mutt, try manually choosing the mime type and
transfer encoding.
After adding the attachment, select it, press Ctrl+t to change the type
to e.g. application/octet-stream, then press Ctrl+e to change the
transfer encoding back to 8bit. Mutt is quite friendly in that regard :)

HTH
Björn
