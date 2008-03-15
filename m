Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYCOVvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYCOVvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYCOVva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:51:30 -0400
Received: from phunq.net ([64.81.85.152]:37766 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182AbYCOVv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:51:29 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 13:51:20 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803151425.49592.phillips@phunq.net> <20080315210846.72bd28f4@the-village.bc.nu>
In-Reply-To: <20080315210846.72bd28f4@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151451.21262.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 14:08, Alan Cox wrote:
> On Sat, 15 Mar 2008 13:25:48 -0800
> Daniel Phillips <phillips@phunq.net> wrote:
> > On Saturday 15 March 2008 13:56, Alan Cox wrote:
> > > > RAID controllers do not have half a terabyte of RAM. Also, you are always
> > > > invited to choose between speed (write back) and reliability (write through).
> > > 
> > > The write back ones are also battery backed properly, and will switched
> > > to write through (flushing out the cache) on the first sniff of a low
> > > battery signal.
> > 
> > In other words, exactly how ramback works.
> 
> No because you don't honour the ordering and tag boundaries as they do.

Sophism.  The statement was "battery backed properly" and "switch on
first sniff", which is example how ramback works.

Daniel
