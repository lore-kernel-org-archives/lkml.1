Return-Path: <linux-kernel-owner+w=401wt.eu-S966221AbXBPI2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966221AbXBPI2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966222AbXBPI2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:28:35 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:12756 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966221AbXBPI2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:28:34 -0500
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 03:28:34 EST
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
	unsupported config options.
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Ian Pratt <ian.pratt@XenSource.com>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <m11wkqimjd.fsf@ebiederm.dsl.xmission.com>
References: <20070216022449.739760547@goop.org>
	 <20070216022531.570154735@goop.org> <45D54BFF.80100@vmware.com>
	 <m11wkqimjd.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 08:14:22 +0000
Message-Id: <1171613663.20666.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2007 08:14:27.0247 (UTC) FILETIME=[79BF23F0:01C751A2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 00:33 -0700, Eric W. Biederman wrote:
> I know there actually has been some work to get kexec actually working under
> Xen but I don't know where that has gone.

kexec/kdump works with Xen 3.0.4 but it's a dom0 only thing so it
doesn't appear in this patchset.

Ian.


