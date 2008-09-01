Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYIAPHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYIAPHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYIAPH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:07:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYIAPH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:07:29 -0400
Date: Mon, 1 Sep 2008 12:06:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Merge multiproto tree
Message-ID: <20080901120601.044ddc30@mchehab.chehab.org>
In-Reply-To: <48B9360D.7030303@gmail.com>
References: <48B9360D.7030303@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Manu,

On Sat, 30 Aug 2008, Manu Abraham wrote:

>  Hello Mauro,
>
>  Please pull from http://jusst.de/hg/multiproto_api_merge/
>  to merge the following Changesets from the multiproto tree.

The need for supporting newer DTV protocols increases day by day, since when
the first multiproto proposal started to be discussed, about two years ago.

At the end of the last year, Steven send one email to the ML with a different 
API proposal. Yet, people decided to wait for your work to be done. People then 
pinged you, from time to time, asking about the completion of multiproto. All 
the times, your answer were that multiproto were not ready yet for production.

I'm aware that your solution seems to be more code-complete than Steven's 
proposal.

But the recent activity on the mailing list regarding his idea (and its, 
so far, positive feedback) and the fact that I was anyway planning to 
have a discussion about the future of the DVB-API at the Linux Plumbers 
Conference 2008 are supporting me in my idea of post-poning such a pull to 
a point in time shortly after this event.

Cheers,
Mauro
