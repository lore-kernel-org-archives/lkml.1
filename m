Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbXGCPCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbXGCPCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbXGCPCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:02:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6618 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbXGCPCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AYv6PDswrVGPJpr2n2vj3hhgWbViBijPbTitdUjRNUsFScE4HRl7MQBQh7ZZ7Tc/2D+E3Crqwa9u1LBXCjNdV5iO19pdws8HPLajACp2zZO/PJ1hWL3MU6gihwxShHVtbduRQapdJY6ugPIGH8ZanMmTY5+upmJ64611lV2YHRk=
Date: Tue, 3 Jul 2007 17:02:10 +0200
From: Florian Attenberger <valdyn@gmail.com>
To: Arne Georg Gleditsch <argggh@dolphinics.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
Message-ID: <20070703150210.GA31495@master.home>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <20070703135949.GB19565@master.home> <87hcol7en2.fsf@pelargir.dolphinics.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87hcol7en2.fsf@pelargir.dolphinics.no>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 04:20:17PM +0200, Arne Georg Gleditsch wrote:
> Florian Attenberger <valdyn@gmail.com> writes:
> > there was one 'special' event at that date:
> > syslog.2.gz:Jul  1 01:59:59 master kernel: Clock: inserting leap second
> > 23:59:60 UTC
> 
> As far as I can tell, no leap second was due to be inserted at 1. of
> July this year.  Is the year set correctly for this box?
>
yep, controlled by ntpd.
You're right according to
ftp://hpiers.obspm.fr/iers/bul/bulc/bulletinc.33
that event shouldn't have been there.

