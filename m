Return-Path: <linux-kernel-owner+w=401wt.eu-S1761875AbXF1U5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875AbXF1U5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbXF1U45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:56:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35864 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759948AbXF1U44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:56:56 -0400
Subject: Re: 2.6 Linux for PowerPC supports kdb?
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: gshan <gshan@alcatel-lucent.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4682007F.2080504@alcatel-lucent.com>
References: <4681D39B.2000604@alcatel-lucent.com>
	 <20070626220520.380c1798.randy.dunlap@oracle.com>
	 <4682007F.2080504@alcatel-lucent.com>
Content-Type: text/plain
Organization: IBM
Date: Thu, 28 Jun 2007 15:56:26 -0500
Message-Id: <1183064186.22547.25.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 14:15 +0800, gshan wrote:
> Randy Dunlap wrote:
> > On Tue, 26 Jun 2007 23:03:55 -0400 Shan, Guo Wen (Gavin) wrote:
> >
> >   
> >> Does anybody knew if 2.6 linux for PowerPC supports kdb?
> >>     
> >
> > PowerPC isn't listed AFAICT:
> > ftp://oss.sgi.com/www/projects/kdb/download/v4.4/README
> >
> > I.e., all that I see are i386, x86_64, and ia64.
> >
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> >   
> Thanks, Randy. So the kgdb is the only tool I could use to debug the 
> kernel right now?

for powerpc you may be able to use xmon.  (see arch/powerpc/xmon/* ).

-Will

