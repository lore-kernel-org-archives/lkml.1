Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbZIHVLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbZIHVLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 17:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIHVLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 17:11:51 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:53659 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbZIHVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 17:11:51 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Tue, 8 Sep 2009 23:11:51 +0200
User-Agent: KMail/1.9.9
Cc: realnc@arcor.de, linux-kernel@vger.kernel.org
References: <20090906205952.GA6516@elte.hu> <20090908013133.59203403@infradead.org> <200909082222.44828.elendil@planet.nl>
In-Reply-To: <200909082222.44828.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909082311.52229.elendil@planet.nl>
X-OriginalArrivalTime: 08 Sep 2009 21:11:52.0950 (UTC) FILETIME=[FCFCD160:01CA30C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009, Frans Pop wrote:
> Arjan van de Ven wrote:
> > the latest version of latencytop also has a GUI (thanks to Ben)
>
> That looks nice, but...
>
> I kind of miss the split screen feature where latencytop would show
> both the overall figures + the ones for the currently most affected
> task. Downside of that last was that I never managed to keep the
> display on a specific task.
[...]
> Would it be possible to have a command line switch that allows to start
> the old textual mode?

I got a private reply suggesting that --nogui might work, and it does.
Thanks a lot Nikos!

> Looks like the man page needs updating too :-)

So this definitely needs attention :-P
Support of the standard -h and --help options would be great too.

Cheers,
FJP
