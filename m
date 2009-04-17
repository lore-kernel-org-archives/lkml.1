Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZDQFrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZDQFrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZDQFr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:47:26 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52291 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZDQFrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:47:25 -0400
Subject: Re: [BUILD FAILURE 03/12] Next April 14 : PPC64
	randconfig	[arch/powerpc/platforms/ps3/setup.c]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Paul Mackerras <paulus@samba.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <49E787DC.2050800@am.sony.com>
References: <1239733704.5344.75.camel@subratamodak.linux.ibm.com>
	 <49E787DC.2050800@am.sony.com>
Content-Type: text/plain; charset=utf-8
Organization: IBM
Date: Fri, 17 Apr 2009 11:17:18 +0530
Message-Id: <1239947239.4875.6.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 12:32 -0700, Geoff Levand wrote:
> On 04/14/2009 11:28 AM, Subrata Modak wrote:
> > Observed the following build error:
> > ---
> > arch/powerpc/platforms/ps3/setup.c:49: error: redefinition of
> > ‘smp_send_stop’
> > include/linux/smp.h:125: error: previous definition of ‘smp_send_stop’
> > was here
> 
> Hi Subrata,
> 
> Thanks for the report.  I submitted a fix to the powerpc ML:
> 
>  http://patchwork.ozlabs.org/patch/26084/

Thanks Geoff.

Regards--
Subrata

> 
> -Geoff
> 

