Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZDVOKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZDVOKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZDVOKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:10:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43245 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZDVOKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:10:37 -0400
Subject: Re: [BUILD FAILURE 04/04] Next April 21 : x86_64 randconfig
	[drivers/built-in.o]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, srinivasa.deevi@conexant.com,
       linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
In-Reply-To: <20090421140847.509f8c59@pedra.chehab.org>
References: <1240332728.9110.40.camel@subratamodak.linux.ibm.com>
	 <20090421140847.509f8c59@pedra.chehab.org>
Content-Type: text/plain
Organization: IBM
Date: Wed, 22 Apr 2009 19:40:18 +0530
Message-Id: <1240409418.26824.0.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 14:08 -0300, Mauro Carvalho Chehab wrote:
> On Tue, 21 Apr 2009 22:22:08 +0530
> Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> 
> > Observed the following build error. Reported this on 8th and 14th April
> > Next build errors:
> > 
> > http://lkml.org/lkml/2009/4/14/473,
> > 
> > Patch was already provided by Randy on 7th April. This is still to hit
> > the tree:
> > http://lkml.org/lkml/2009/4/7/400,
> > 
> 
> Probably Stephen picked from my tree before I merge this patch on my linux-next tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=c4f0ad35d1df1fed5fae477f806aa8daf5545520
> 
> This error should disappear on the today's build.

Great. Thanks.

--Subrata

> 

