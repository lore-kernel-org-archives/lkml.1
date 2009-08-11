Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZHKUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZHKUkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZHKUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:40:17 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:34328 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZHKUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:40:16 -0400
Date: Tue, 11 Aug 2009 23:40:06 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, me@felipebalbi.com,
       Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Question about userspace-consumer
Message-ID: <20090811204006.GA13969@gandalf>
Reply-To: me@felipebalbi.com
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <4A815F64.8000105@compulab.co.il>
 <20090811125603.GH24947@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811125603.GH24947@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 01:56:03PM +0100, Mark Brown wrote:
> On Tue, Aug 11, 2009 at 03:09:08PM +0300, Mike Rapoport wrote:
> > Felipe Balbi wrote:
> 
> > > that said, power supply framework and regulator framework seem to be
> > > well enough for implementing the basic support for SBS-enabled charging
> > > scheme.
> 
> > As far as I understood SBS scheme, the host has very little impact on the
> > charging process. Most of the charging is handled by Smart Battery and Smart
> > Battery Charger without any host intervention.
> 
> I strongly suspect that in at least some designs the battery charger
> itself will be at least partially dumb and the battery charger part of
> the spec done by software running on the host CPU - there's examples in
> the spec which seem to back that up.

and that's what I was talking about. I'll reply more to the other
subthread.

-- 
balbi
