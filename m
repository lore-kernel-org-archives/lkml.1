Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYFWPft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYFWPft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbYFWPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:35:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYFWPfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:35:41 -0400
Subject: Re: [Cluster-devel] Re: [Bug 10827] 2.6.26rc4 GFS2 oops.
From: Bob Peterson <rpeterso@redhat.com>
Reply-To: rpeterso@redhat.com
To: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cluster-devel@redhat.com,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org,
       Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <20080623151417.GA28779@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A.nME.ZJDVIB@albercik>
	 <20080622090906.GD27069@cs181133002.pp.htv.fi>
	 <1214232039.3724.66.camel@technetium.msp.redhat.com>
	 <20080623151417.GA28779@cs181140183.pp.htv.fi>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Mon, 23 Jun 2008 10:32:42 -0500
Message-Id: <1214235162.3724.71.camel@technetium.msp.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yup, the patch in your Bugzilla is for code that is new in 2.6.26.
> 
> Can you push your patch for inclusion into 2.6.26 so that 2.6.26 won't 
> get released with this regression?
> 
> Thanks
> Adrian

Hi Adrian,

Unfortunately, I cannot.  All access to the gfs2 "-nmw" git tree is
controlled by Steve Whitehouse, and he is on vacation/holiday until
tomorrow.

I've submitted the patch to cluster-devel, so hopefully he'll push it
as soon as he returns tomorrow.

Regards,

Bob Peterson
Red Hat GFS


