Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXIXLn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXIXLn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXIXLnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:43:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:58662 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753842AbXIXLnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:43:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+vsbAMeLSvsYYefW2IE5UPKJBB5e77wtgIpWlI4d
	U8DYTYaBsD1y14
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20070924130851.201d18ed@twins>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920075155.GA31641@elte.hu>
	 <1190275870.9232.6.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
	 <1190455308.7404.19.camel@Homer.simpson.net>
	 <1190531662.11524.15.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
	 <1190628609.6389.14.camel@Homer.simpson.net>
	 <20070924122422.75562c41@twins> <1190630535.7406.2.camel@Homer.simpson.net>
	 <20070924130851.201d18ed@twins>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 13:43:12 +0200
Message-Id: <1190634192.7267.8.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 13:08 +0200, Peter Zijlstra wrote:

> Its perfectly valid for min_vruntime to exist in 1ULL << 63.

But wrap backward timewarp is what's killing my box.

	-Mike

