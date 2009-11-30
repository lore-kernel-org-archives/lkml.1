Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZLADaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZLADaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 22:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZLADaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 22:30:19 -0500
Received: from zbasel.fortytwo.ch ([193.138.215.60]:43281 "EHLO
	zbasel.fortytwo.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZLADaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 22:30:18 -0500
From: Adrian von Bidder <avbidder@fortytwo.ch>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: acerhdf: stilll fighting between kernel and BIOS?
Date: Mon, 30 Nov 2009 19:02:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-1-686; KDE/4.3.2; i686; ; )
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <200911200823.58897@fortytwo.ch> <200911231018.00163@fortytwo.ch> <84144f020911230158lecd54c2xbf5380602c02c2fd@mail.gmail.com>
In-Reply-To: <84144f020911230158lecd54c2xbf5380602c02c2fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911301902.42262@fortytwo.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 November 2009 10.58:54 Pekka Enberg wrote:
> On Mon, Nov 23, 2009 at 11:17 AM, Adrian von Bidder
> 
> <avbidder@fortytwo.ch> wrote:
> > Heyho!
> >
> > On Sunday 22 November 2009 22.27:50 Peter Feuerer wrote:
> >> issues with AOA 150 netbooks should be solved with current 2.6.32-git
> >>  tree. You can also try to use latest acerhdf of http://piie.net
> >
> > Seems to work fine.  That was the fix I thought was already included in
> > 2.6.31.
> 
> Is that commit ded0cdfc6a7673916b0878c32fa8ba566b4f8cdb ("acerhdf: fix
> fan control for AOA150 model")? Should it go to -stable?

Sorry for not answering sooner.

I don't really have time to recompile / test more at this time; in any case, 
I think it's just a minor annoyance and not what I'd feed into a "fixes 
only" tree.  (I'm not involved in kernel development in any way, but I 
thought that the stable tree should be quite limited in what goes in?)

cheers
-- vbi



-- 
<towo> Alle schlauen Amerikaner arbeiten bei der NSA,
       und die dürfen nicht mit Ausländern sprechen.
        -- #Debian.DE
