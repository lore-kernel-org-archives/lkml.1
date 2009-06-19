Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZFSByT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZFSByT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZFSByH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:54:07 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:59436 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZFSByG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:54:06 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 15/32] union-mount: Documentation 
To: Valerie Aurora <vaurora@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz
In-Reply-To: <20090618190558.GB22206@shell>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-16-git-send-email-jblunck@suse.de> <8417.1243232743@jrobl> <200905250903.08165.arnd@arndb.de> <7294.1243240990@jrobl> <20090618190558.GB22206@shell>
Date: Fri, 19 Jun 2009 10:53:13 +0900
Message-ID: <14264.1245376393@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> Ah, we did implement that in an earlier version.  I don't know if we
> dropped the patch by accident or on purpose, but the original version
> is below.  We will either put this feature back or fix the
> documentation.  Thanks!

I see, it was implemented originally.
How about link(2)? Was it implemented too?
I am afraid current unionmount does not support link when the source
file exists on the lower fs.


J. R. Okajima
