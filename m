Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZLAQsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZLAQsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZLAQsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:48:02 -0500
Received: from mail.gmx.net ([213.165.64.20]:51435 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753665AbZLAQsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:48:01 -0500
X-Authenticated: #14349119
X-Provags-ID: V01U2FsdGVkX1+yHqAZKEeyZmF/6/8X/UE7ru8K6GG3Zu9j4EB+Mn
	UU9KCIlYWibNbi
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
From: Mike Galbraith <gleep@gmx.de>
To: Jan Kara <jack@suse.cz>
Cc: James Y Knight <foom@fuhm.net>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, npiggin@suse.de
In-Reply-To: <20091201160324.GA25873@quack.suse.cz>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
	 <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net>
	 <1259667765.9614.19.camel@marge.simson.net>
	 <20091201143558.GB12730@quack.suse.cz>
	 <20091201160324.GA25873@quack.suse.cz>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 17:47:58 +0100
Message-Id: <1259686078.6229.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 17:03 +0100, Jan Kara wrote:

>   The patch below fixes the issue for me...

Ditto.

	-Mike

