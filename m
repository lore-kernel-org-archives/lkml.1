Return-Path: <linux-kernel-owner+w=401wt.eu-S1765029AbXHORMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765029AbXHORMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXHORMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:12:15 -0400
Received: from smtp122.sbc.mail.re3.yahoo.com ([66.196.96.95]:21138 "HELO
	smtp122.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752774AbXHORMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:12:14 -0400
X-YMail-OSG: tL5gj6oVM1k2n.FdhG366Akin_UVA0vR5M2pFRe9Asb.1D9pPcUKPHuUpoKlnXEwoSDXs7EFEG_09ybQfvYdW3jcyZ04TLrAOd893eKdb.cCG.TADS4-
Date: Wed, 15 Aug 2007 12:12:10 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Jackson <pj@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, clameter@sgi.com,
       serge@hallyn.com, dhaval@linux.vnet.ibm.com, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, balbir@in.ibm.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ckrm-tech@lists.sourceforge.net
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
Message-ID: <20070815171210.GB13286@vino.hallyn.com>
References: <1187103831.6281.24.camel@localhost> <20070814180339.GA32553@vino.hallyn.com> <1187115224.6281.40.camel@localhost> <20070814192306.GB32553@vino.hallyn.com> <20070814204951.GA2065@vino.hallyn.com> <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com> <1187127685.6281.139.camel@localhost> <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com> <1187185392.5422.13.camel@localhost> <20070815092954.bfe7e86d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815092954.bfe7e86d.pj@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Jackson (pj@sgi.com):
> Lee wrote:
> > [altho' methinks CPUSET should select CONTAINERS rather than
> > depend on it...]
> 
> Good point -- what do you think, Paul Menage?

Paul mentioned (http://www.spinics.net/lists/linux-containers/msg03775.html)
that he was asked not to use select in Kconfigs any more.

-serge
