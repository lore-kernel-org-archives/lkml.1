Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0CMO5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:57:15 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14961 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab0CMO5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:57:13 -0500
Subject: Re: Regression in i915 on 2.6.34-rc1
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dri-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100312234000.1ce16ec4@redhat.com>
References: <20100311003358.58194366@redhat.com>
	 <20100312182519.3723e970@redhat.com> <1268458676.28444.9.camel@dc7800.home>
	 <20100312234000.1ce16ec4@redhat.com>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 07:49:53 -0700
Message-Id: <1268491793.28444.12.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 23:40 -0700, Pete Zaitcev wrote:
> On Fri, 12 Mar 2010 22:37:56 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > Thanks for the report.  Would you mind posting the entire dmesg
> > log, /proc/iomem contents, and "lspci -vv" output somewhere (maybe in
> > bugzilla)?
> > 
> > The quote below isn't enough for me to see the problem, but
> > http://bugzilla.kernel.org/show_bug.cgi?id=15480 is another regression
> > related to this commit. []
> 
> Do you prefer me to attach the requested data to Yanko's bug, or
> file a new one for now?

Personally, I guess I'd file a new one, on the assumption that you're
seeing a different problem.

Bjorn


