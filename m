Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZK0WzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZK0WzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZK0WzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:55:14 -0500
Received: from waste.org ([173.11.57.241]:46873 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbZK0WzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:55:13 -0500
Subject: Re: Re:
From: Matt Mackall <mpm@selenic.com>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, jeff@garzik.org
In-Reply-To: <4B0E6B02.8020705@collabora.co.uk>
References: <1259197403.2858.88.camel@calx>
	 <1259232570-11918-1-git-send-email-ian.molton@collabora.co.uk>
	 <1259235525.9212.444.camel@calx>  <4B0E6B02.8020705@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 16:54:56 -0600
Message-ID: <1259362496.25403.165.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 11:48 +0000, Ian Molton wrote:
> Matt Mackall wrote:
> > On Thu, 2009-11-26 at 10:49 +0000, Ian Molton wrote:
> >> Hi guys,
> >>
> > 
> > No need to pass rng_buffer to the helper as there's only one with global
> > scope.
> 
> Ah, sorry, I see what you mean now. The logic behind that is that it
> matches the new API, whcih is all that will be left once the old drivers
> are patched to use it. I planned to drop the helper altogether at that
> point and though it'd make the patch more readable when that happens.

Ok, that's quite reasonable.

> Is this enough to get an acked-by: ? If so, I'll do that and see about
> getting the change into linux-next.

Acked-by: Matt Mackall <mpm@selenic.com>

You should probably go through Herbert's tree to get into -next,
hopefully he won't be too miffed by your repeated failure to cc:
linux-kernel initially and failure to cc: him here..

-- 
http://selenic.com : development and support for Mercurial and Linux


