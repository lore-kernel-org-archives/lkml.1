Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbXFRWBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbXFRWBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbXFRWBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:01:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:5233 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933291AbXFRWB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:01:29 -0400
Date: Tue, 19 Jun 2007 00:01:25 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Joshua David Williams <yurimxpxman.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GPLv3 dispute solution - new open source license?
Message-ID: <20070618220125.GB13538@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Joshua David Williams <yurimxpxman.lkml@gmail.com>,
	linux-kernel@vger.kernel.org
References: <200706181747.23230.yurimxpxman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706181747.23230.yurimxpxman@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think that one of the main problems with the GPLv2 versus
GPLv3 dispute is the discord that it saws between developers
around the world.  Right now, 66% is GPL, 6.5% is LGPL (using
the stats from freshmeat here), 6% BSD, and the rest can
be neglected ;) (see bottom of http://freshmeat.net/stats/)

That means that if someone decides that he wants to write
free software (and license it under the GPL), he can choose
from a large code base.

What those stats don't say, however - is how many people
said "version 2 or later", and how many said "version 2".

If next people start to write software - they might be
forced to use GPLv2 because they want to use other software
that was only version 2. While others will start to write
new software under version 3 (if only because they don't
know better - like 90% of the people who copied the template
with "version 2 or later").

The result is that two seperate groups of software will
start to emerge that cannot use from eachother. And because
both will be consirably large, that is a Bad Thing(tm).

Imho, it is much worse that this seperation of the pool of
open source code will occur than everyone using version 2,
or everyone using version 3, and the effect that that will
have.

Now, writing yet another license for the linux kernel is
therefore NOT the solution - if you get my drift.

-- 
Carlo Wood <carlo@alinoe.com>
