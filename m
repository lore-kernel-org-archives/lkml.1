Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYIJMJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYIJMJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYIJMJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:09:39 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:36342 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYIJMJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:09:38 -0400
Date: Wed, 10 Sep 2008 14:09:34 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Brice Goglin <brice@myri.com>, Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [Bug #11334] myri10ge: use ioremap_wc: compilation failure on ARM
Message-ID: <20080910120934.GA23772@xi.wantstofly.org>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik> <Wz8EH5sroeE.A.aLC.aqwwIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Wz8EH5sroeE.A.aLC.aqwwIB@albercik>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 11:30:38PM +0200, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
> Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
> Submitter	: Martin Michlmayr <tbm@cyrius.com>
> Date		: 2008-08-10 11:25 (28 days old)
> References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2
> Handled-By	: Lennert Buytenhek <buytenh@wantstofly.org>
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11334#c13

The patch to fix this is upstream now (in -rc6), as commit
1ad77a876da48331451698cc4172c90ab9b6372f.
