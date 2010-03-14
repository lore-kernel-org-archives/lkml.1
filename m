Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab0CNDJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 22:09:47 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:17463 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0CNDJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 22:09:46 -0500
Subject: Re: Regression in i915 on 2.6.34-rc1
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dri-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100313134642.797c35d6@redhat.com>
References: <20100311003358.58194366@redhat.com>
	 <20100312182519.3723e970@redhat.com> <1268458676.28444.9.camel@dc7800.home>
	 <20100313134642.797c35d6@redhat.com>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 20:02:24 -0700
Message-Id: <1268535744.28444.16.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 13:46 -0700, Pete Zaitcev wrote:
> On Fri, 12 Mar 2010 22:37:56 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > Thanks for the report.  Would you mind posting the entire dmesg
> > log, /proc/iomem contents, and "lspci -vv" output somewhere (maybe in
> > bugzilla)?
> 
> Done, new bug:
> http://bugzilla.kernel.org/show_bug.cgi?id=15533

Thanks!  Sorry, I should have asked for the "pci=nocrs" (working) dmesg,
too.  Do you have that handy?  What kind of machine is this?  I don't
suppose you have Windows on it; I'd really like to know what the Device
Manager says about the PCI host bridge and graphics controller
resources.

Bjorn


