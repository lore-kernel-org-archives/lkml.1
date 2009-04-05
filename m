Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZDEIyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZDEIyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZDEIyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:54:11 -0400
Received: from www.tglx.de ([62.245.132.106]:35248 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZDEIyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:54:09 -0400
Date: Sun, 5 Apr 2009 10:53:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: GeunSik Lim <leemgs1@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: Re: [Announce] 2.6.29.1-rt4
In-Reply-To: <alpine.LFD.2.00.0904051038350.747@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904051052560.747@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>  <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>  <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> 
 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>  <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>  <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>  <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain> 
 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>  <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain> <49b7c2350904042028q8865f80tcf56500e8a009c0d@mail.gmail.com> <alpine.LFD.2.00.0904051038350.747@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Apr 2009, Thomas Gleixner wrote:

> GeunSik,
> 
> On Sun, 5 Apr 2009, GeunSik Lim wrote:
> > I have one question. What is "broken-out" 's meaning  for rt patch file?
> 
> The broken out tar ball contains a patch series of smaller patches,
> which need to be applied in a give order. The order is determined from
> the series file. It's a "quilt" series. quilt is a patch series
> management tool. "man script" 

Of course I meant: man quilt

   tglx
