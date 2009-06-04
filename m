Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZFDAtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZFDAtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZFDAth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:49:37 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55208 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbZFDAtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ocgbYbaExTAETiArHZl00PIH/yH03pnRgBzRLhi3JnB2i72wP8O0o0yAZA8jsxWdjM
         4tjAWWBWoPQNTTX2u1Y+wZuQgkm+sdwWycKyjhO9+aQ+eMGHZJoOZuOjBeS2NN6WBVX3
         pJ+2GS1C/q6LpOvCvBXw6fYfojB2u7Kk8FbRw=
Date: Thu, 4 Jun 2009 04:49:21 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, davem@davemloft.net,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sergey Lapin <slapin@ossfans.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 1/6] crc-itu-t: add bit-reversed calculation
Message-ID: <20090604004921.GC32561@doriath.ww600.siemens.net>
References: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com> <1244021629-18409-2-git-send-email-dbaryshkov@gmail.com> <1244033004.21215.4.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244033004.21215.4.camel@deadeye>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 01:43:24PM +0100, Ben Hutchings wrote:
> On Wed, 2009-06-03 at 13:33 +0400, Dmitry Eremin-Solenikov wrote:
> [...] 
> > +/**
> > + * crc_itu_t_bitreversed - Compute the CRC-ITU-T for the data buffer;
> > + * the buffer content is assumed to be bit-reversed
> [...]
> 
> This short description spills onto two lines which is invalid and breaks
> the generation of docs.  Sorry to point this out after recommending the
> patch to you.
> 
> I've changed the description to "crc_itu_t_bitreversed - Compute the
> CRC-ITU-T for a bit-reversed data buffer" all on one line.

Anyway, this patch isn't necessary for the first round of patches, we
are submitting now (got in by a mistake).


-- 
With best wishes
Dmitry

