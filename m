Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYILVQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYILVQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbYILVQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:16:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbYILVQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:16:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Bug #11548] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Fri, 12 Sep 2008 23:21:32 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.PRG.8bsyIB@albercik> <1221252989.8709.11.camel@think.oraclecorp.com>
In-Reply-To: <1221252989.8709.11.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809122321.33257.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 of September 2008, Chris Mason wrote:
> On Fri, 2008-09-12 at 21:06 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> 
> This is still a bug, but I haven't tried this workload on 2.6.26, so I'm
> not sure it is a regression.  Unfortunately, I won't be able to test it
> again until after the plumber's conference.

That's fine.  In case it turns out to be a regression, it's better to list it
for now IMO. :-)

Thanks,
Rafael
