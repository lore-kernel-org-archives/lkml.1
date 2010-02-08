Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0BHH0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:26:38 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39593 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab0BHH0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:26:37 -0500
Subject: Re: [PATCH]: Changed in LTP maintainership responsibilities
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, svishuku@in.ibm.com,
       "paul.larson" <paul.larson@ubuntu.com>,
       Garrett Cooper <yanegomi@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
       Rishikesh <risrajak@linux.vnet.ibm.com>,
       Robbie Williamson <robbie@ubuntu.com>,
       "manoj.iyer" <manoj.iyer@ubuntu.com>, Nathan Straz <nstraz@redhat.com>,
       Michael Reed <mreed10@us.ibm.com>, Sudarshan Rao <rsudarsh@in.ibm.com>
In-Reply-To: <4B6FAD84.5070804@linux.vnet.ibm.com>
References: <4B6FAD84.5070804@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Mon, 08 Feb 2010 12:56:19 +0530
Message-Id: <1265613979.4754.16.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 11:51 +0530, Rishikesh wrote:
> Hi List,
> 
> Please include this patch in mainline kernel.
> 
> LTP maintainer responsibities have changed from 2010.
> 
> Ref: http://marc.info/?l=ltp-list&m=126502242912536&w=2
> 
> Signed-off By : Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>

Can you please also add Garretś name, and the names in the following
order:

+M:     Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
+M:	Garrett Cooper <yanegomi@gmail.com>
+M:     Mike Frysinger <vapier@gentoo.org>
+M:     Subrata Modak <subrata@linux.vnet.ibm.com>

Regards--
Subrata

> ---
> Index: linux-2.6/MAINTAINERS
> ===================================================================
> --- linux-2.6.orig/MAINTAINERS  2010-02-08 11:27:59.000000000 +0530
> +++ linux-2.6/MAINTAINERS       2010-02-08 11:44:42.000000000 +0530
> @@ -3411,6 +3411,7 @@
>   F:     drivers/scsi/sym53c8xx_2/
> 
>   LTP (Linux Test Project)
> +M:     Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
>   M:     Subrata Modak <subrata@linux.vnet.ibm.com>
>   M:     Mike Frysinger <vapier@gentoo.org>
>   L:     ltp-list@lists.sourceforge.net (subscribers-only)
> 

