Return-Path: <linux-kernel-owner+w=401wt.eu-S2992783AbXCCARd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992783AbXCCARd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992789AbXCCARd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:17:33 -0500
Received: from gw.goop.org ([64.81.55.164]:40189 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992783AbXCCARd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:17:33 -0500
Message-ID: <45E8BE79.40200@goop.org>
Date: Fri, 02 Mar 2007 16:16:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tim.c.chen@linux.intel.com
CC: linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: system call time increase when turning on CONFIG_PARAVIRT
References: <1172866274.4898.14.camel@localhost.localdomain>	 <45E89CFB.4090905@goop.org> <1172877111.8383.4.camel@localhost.localdomain>
In-Reply-To: <1172877111.8383.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> I also hope that the performance can be recovered as this option could
> enabled in distributions' kernels in future.

Yes, the intent is that running a CONFIG_PARAVIRT kernel on native
hardware will have negligible performance hit compared to running a
non-paravirt kernel.

    J
