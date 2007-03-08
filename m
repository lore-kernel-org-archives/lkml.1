Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXCHSfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXCHSfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXCHSfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:35:03 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:42838 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800AbXCHSfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:35:00 -0500
Date: Thu, 8 Mar 2007 10:30:08 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308183008.GI19575@sequoia.sous-sol.org>
References: <45EEF966.6060902@goop.org> <Line.LNX.4.64.0703071304080.1851@d.namei> <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <45EF4C81.4000109@goop.org> <45EF4D57.5030900@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EF4D57.5030900@vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Zachary Amsden (zach@vmware.com) wrote:
> s/do/will (smpboot.c)

Well the current Xen mechanism rather dodges all of that (for bits like
IPI apicid).

thanks,
-chris
