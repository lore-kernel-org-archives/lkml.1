Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZCQPuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZCQPuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZCQPua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:50:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:56499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZCQPu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:50:29 -0400
Date: Tue, 17 Mar 2009 14:20:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hannes Eder <hannes@hanneseder.net>, trivial@kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/15] NULL noise:
 drivers/media/dvb/frontends/drx397xD_fw.h
In-Reply-To: <20090309075832.67483c8e@caramujo.chehab.org>
Message-ID: <alpine.LNX.2.00.0903171419490.11733@jikos.suse.cz>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191435.30062.72139.stgit@f10box.hanneseder.net> <20090309075832.67483c8e@caramujo.chehab.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Mauro Carvalho Chehab wrote:

> > Fix this sparse warnings:
> >   drivers/media/dvb/frontends/drx397xD_fw.h:21:2: warning: Using plain integer as NULL pointer
> >   drivers/media/dvb/frontends/drx397xD_fw.h:22:2: warning: Using plain integer as NULL pointer
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Doesn't seem to be present in current -next/-mmotim, applied to trivial 
tree.

-- 
Jiri Kosina
