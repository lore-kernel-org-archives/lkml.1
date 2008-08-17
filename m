Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYHQMcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYHQMcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYHQMcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:32:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYHQMcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:32:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [Bug #11334] myri10ge: use ioremap_wc: compilation failure on ARM
Date: Sun, 17 Aug 2008 14:35:14 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Brice Goglin <brice@myri.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.ZxE.XazpIB@albercik> <20080817062724.GA2563@deprecation.cyrius.com>
In-Reply-To: <20080817062724.GA2563@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171435.15446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Martin Michlmayr wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2008-08-16 21:02]:
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> 
> This is still there.

Thanks for the update.

Rafael

