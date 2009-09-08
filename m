Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZIHUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZIHUWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZIHUWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 16:22:44 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:50459 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbZIHUWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 16:22:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Tue, 8 Sep 2009 22:22:43 +0200
User-Agent: KMail/1.9.9
Cc: realnc@arcor.de, linux-kernel@vger.kernel.org
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org> <20090907074039.1b6bc1ac@infradead.org> <4AA6056A.4020106@arcor.de> <4AA6056A.4020106@arcor.de> <20090908013133.59203403@infradead.org>
In-reply-To: <20090908013133.59203403@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909082222.44828.elendil@planet.nl>
X-OriginalArrivalTime: 08 Sep 2009 20:22:45.0504 (UTC) FILETIME=[202C4000:01CA30C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> the latest version of latencytop also has a GUI (thanks to Ben)

That looks nice, but...

I kind of miss the split screen feature where latencytop would show both 
the overall figures + the ones for the currently most affected task. 
Downside of that last was that I never managed to keep the display on a 
specific task.

The graphical display also makes it impossible to simply copy and paste 
the results.

Having the freeze button is nice though.

Would it be possible to have a command line switch that allows to start 
the old textual mode?

Looks like the man page needs updating too :-)

Cheers,
FJP
