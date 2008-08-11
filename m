Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYHKPfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYHKPfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYHKPfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:35:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40980 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYHKPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:35:45 -0400
Subject: Re: [Cbe-oss-dev] please pull cell merge branch
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>, oprofile-list@lists.sourceforge.net,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <200808110918.57293.arnd@arndb.de>
References: <1217620879.15667.145.camel@carll-linux-desktop>
	 <200808091513.05251.arnd@arndb.de>
	 <18591.30474.127939.243247@cargo.ozlabs.ibm.com>
	 <200808110918.57293.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 08:34:44 -0700
Message-Id: <1218468884.6637.114.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-08-11 at 09:18 +0200, Arnd Bergmann wrote:
> On Monday 11 August 2008, Paul Mackerras wrote:
> > Arnd Bergmann writes:
> > > I've fixed one last bug in Carl's update for cell-oprofile (int flags
> > > instead of unsigned long flags) and made sure the comments fit the
> > > usual style. This fixes a long-standing bug that prevented us from
> > > using oprofile on SPUs in many real-world scenarios. 
> >
> > Since you're touching generic oprofile code here, do you have an ack 
> > from the oprofile maintainer?  Or is the oprofile maintainer listed in
> > MAINTAINERS (Robert Richter) no longer active or something?
> > 
> 
> Sorry about that. I had assumed that at the very least Carl had had
> the oprofile list on Cc and that people there just didn't care.
> 
> Robert has just recently taken over maintainership for oprofile,
> so I assume that he is indeed active and interested in the patches.
> I'll send them out again for his review on oprofile-list.
> 
> 	Arnd <><

Sorry, my mistake.  I did mean to post both patches to the OProfile list
as well.  I was planning on following up with Robert on the patches this
week since I had not heard from him.  

           Carl Love

