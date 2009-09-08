Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZIHI2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZIHI2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZIHI2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:28:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:47339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZIHI2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:28:10 -0400
Date: Tue, 8 Sep 2009 01:31:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908013133.59203403@infradead.org>
In-Reply-To: <4AA6056A.4020106@arcor.de>
References: <20090906205952.GA6516@elte.hu>
	<h81v7t$p6e$1@ger.gmane.org>
	<20090907074039.1b6bc1ac@infradead.org>
	<4AA6056A.4020106@arcor.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Sep 2009 10:19:06 +0300
Nikos Chantziaras <realnc@arcor.de> wrote:

> latencytop has this to say:
> 
>    http://foss.math.aegean.gr/~realnc/pics/latop1.png
> 
> Though I don't really understand what this tool is trying to tell me,
> I hope someone does.

unfortunately this is both an older version of latencytop, and it's
incorrectly installed ;-(
Latencytop is supposed to translate those cryptic strings to english,
but due to not being correctly installed, it does not do this ;(

the latest version of latencytop also has a GUI (thanks to Ben) 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
