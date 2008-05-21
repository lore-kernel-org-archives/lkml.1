Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbYEUULO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbYEUULO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936553AbYEUUKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:10:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:16062 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937262AbYEUUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bC9zh34YlwYMj+QpRPk36ev4jBP+MjyY+eGNzDG0rBewMhNtB0FdYUdRuukqs2QOVVWmkhDmAi0QMyLEIZSmTsVcLK2v8KZyfMqa1PPqm3FcFb5Bwq5iNZ12J/n2Tahqzg/ueDuNWXB9wkFzdgZgBT5+w9h1KN6q49oCbfJJa1U=
Message-ID: <8bd0f97a0805211310t650ccbb1u9a2ecf789ce74458@mail.gmail.com>
Date: Wed, 21 May 2008 16:10:00 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Cc: "Felipe Balbi" <me@felipebalbi.com>, "Tony Lindgren" <tony@atomide.com>,
       "Bryan Wu" <cooloney@kernel.org>, linux-omap@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200805211304.53082.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
	 <200805211014.45170.david-b@pacbell.net>
	 <61cdb2dcc22913ddefddd7b4a6faede3@felipebalbi.com>
	 <200805211304.53082.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 4:04 PM, David Brownell wrote:
> That said, I'm looking forward to seeing the www.beagleboard.org
> hardware [1] become more generally available.  That will make some
> musb_hdrc hardware available in a more developer-friendly rig than,
> say, an N810 tablet.  And it might well get more folk in a position
> where they can use that driver!  (I think some Blackfin devboards
> are available already, but they're more pricey.)

unfortunately, that is the case.  the BF527 EZKit is ~$900 while the
BF548 EZKit is ~$1000.  i'm hoping us software guys keep complaining
enough for the hardware guys to put out a bare bone kit at a
reasonable price (sub $300).
-mike
