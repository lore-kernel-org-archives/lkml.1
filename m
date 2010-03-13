Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835Ab0CMUst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:48:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022Ab0CMUsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:48:46 -0500
Date: Sat, 13 Mar 2010 13:46:42 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: dri-devel@lists.sourceforge.net, zaitcev@redhat.com,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: Regression in i915 on 2.6.34-rc1
Message-ID: <20100313134642.797c35d6@redhat.com>
In-Reply-To: <1268458676.28444.9.camel@dc7800.home>
References: <20100311003358.58194366@redhat.com>
	<20100312182519.3723e970@redhat.com>
	<1268458676.28444.9.camel@dc7800.home>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 22:37:56 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Thanks for the report.  Would you mind posting the entire dmesg
> log, /proc/iomem contents, and "lspci -vv" output somewhere (maybe in
> bugzilla)?

Done, new bug:
http://bugzilla.kernel.org/show_bug.cgi?id=15533

-- Pete
