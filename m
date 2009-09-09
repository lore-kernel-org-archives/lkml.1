Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZIIJxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZIIJxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZIIJxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:53:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:60419 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZIIJxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:53:20 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>, realnc@arcor.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200909082222.44828.elendil@planet.nl>
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org>
	 <20090907074039.1b6bc1ac@infradead.org> <4AA6056A.4020106@arcor.de>
	 <4AA6056A.4020106@arcor.de> <20090908013133.59203403@infradead.org>
	 <200909082222.44828.elendil@planet.nl>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 19:53:08 +1000
Message-Id: <1252489988.26522.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 22:22 +0200, Frans Pop wrote:
> Arjan van de Ven wrote:
> > the latest version of latencytop also has a GUI (thanks to Ben)
> 
> That looks nice, but...
> 
> I kind of miss the split screen feature where latencytop would show both 
> the overall figures + the ones for the currently most affected task. 
> Downside of that last was that I never managed to keep the display on a 
> specific task.

Any idea of how to present it ? I'm happy to spend 5mn improving the
GUI :-) 

> The graphical display also makes it impossible to simply copy and paste 
> the results.

Ah that's right. I'm not 100% sure how to do that (first experiments
with gtk). I suppose I could try to do some kind of "snapshot" feature
which saves the results in textual form.

> Having the freeze button is nice though.
> 
> Would it be possible to have a command line switch that allows to start 
> the old textual mode?

It's there iirc. --nogui :-)

Cheers,
Ben.

> Looks like the man page needs updating too :-)
> 
> Cheers,
> FJP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

