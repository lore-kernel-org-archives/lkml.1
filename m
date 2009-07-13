Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZGMRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZGMRAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZGMRAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:00:40 -0400
Received: from mail.atheros.com ([12.36.123.2]:10263 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbZGMRAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:00:40 -0400
Date: Mon, 13 Jul 2009 10:00:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Julia Lawall <julia@diku.dk>, "gregkh@suse.de" <gregkh@suse.de>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
Message-ID: <20090713170038.GA12919@mosca>
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>
 <4A584A94.5010105@gmail.com>
 <1247307444.3032.2.camel@hpdv5.satnam>
 <1247308323.3032.5.camel@hpdv5.satnam>
 <4A5872FD.8040500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A5872FD.8040500@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 04:09:49AM -0700, Jiri Slaby wrote:
> On 07/11/2009 12:32 PM, Jaswinder Singh Rajput wrote:
> > And more funny thing is that all functions are global in this file.
> >
> > Greg, can you please check the scope of these function, why all are
> > global.
> 
> Why don't you do that? I think patches are welcome :).

I will note Otus has a replacement ar9170 driver already upstream,
as soon as it gets aggregation support otus will be dropped. Better
focus on ar9170 instead if you are looking to spend some cycles on
driver help.

  Luis
