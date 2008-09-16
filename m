Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYIPQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYIPQZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYIPQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:25:11 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:12059 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbYIPQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:25:09 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
In-Reply-To: <48CFD7C3.5080207@opengridcomputing.com>
References: <48B2D7F8.5020206@opengridcomputing.com>
	 <20080826192711.GJ4380@fieldses.org>
	 <48B567F5.2090605@opengridcomputing.com>
	 <1220111261.31172.14.camel@localhost.localdomain>
	 <20080831193037.GB14876@fieldses.org>
	 <1220211842.31172.18.camel@localhost.localdomain>
	 <48BAF643.4070808@opengridcomputing.com>
	 <1220217505.31172.26.camel@localhost.localdomain>
	 <48BC2466.2070806@opengridcomputing.com>
	 <1221036015.24993.27.camel@zakaz.uk.xensource.com>
	 <20080912224323.GN22126@fieldses.org>
	 <48CAF80A.4010109@opengridcomputing.com>
	 <1221296243.2534.7.camel@localhost.localdomain>
	 <1221544139.2534.18.camel@localhost.localdomain>
	 <48CF9AC3.6060801@opengridcomputing.com>
	 <1221577412.28572.60.camel@zakaz.uk.xensource.com>
	 <48CFD7C3.5080207@opengridcomputing.com>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 17:24:45 +0100
Message-Id: <1221582285.28572.67.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=unbeb6qN2T0A:10 a=497XeZ5pv4kA:10 a=3cdy94UXQTS5tFs9gVQA:9 a=9z2sAvtuhiPYKwClwRnyFpSWTh0A:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 10:58 -0500, Tom Tucker wrote:
> I'll send you a patch for the server.

Thanks. It's running 2.6.25.7 although I can massage a more recent patch
if needed. (I'm a bit less keen to run a variety of random kernels on
that machine).

Ian.

-- 
Ian Campbell
Current Noise: The Ocean - Protoerozoic - Rhyacian - Untimely Meditations

We may not return the affection of those who like us, but we always respect
their good judgement.

