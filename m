Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829Ab0ALX41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0ALX41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793Ab0ALX41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:56:27 -0500
Received: from comsrv.aao.GOV.AU ([192.231.167.2]:43229 "HELO
	comsrv.aao.gov.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752712Ab0ALX40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:56:26 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 18:56:25 EST
Date: Wed, 13 Jan 2010 10:52:21 +1100
From: Scott Smedley <ss@aao.gov.au>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Message-ID: <20100112235221.GA20761@aao.gov.au>
Reply-To: ss@aao.gov.au
References: <201001122242.22774.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001122242.22774.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marin,

> dt3155 frame grabber I am using in my experiments since 
> the time of 2.6.17 kernel.

Whoah!

> I will really appreciate your comments, suggestions, criticism.

I haven't tried your driver but the code looks much neater than
our driver. Still, I am wondering why you chose to implement a
device driver from scratch, rather than use an existing one?

http://sourceforge.net/projects/dt3155a/

I'll leave decisions about whether to merge or discard (either
driver) to Greg. My 2 cents is that there should only be 1 DT3155
driver for users to choose from.

Scott. :)
