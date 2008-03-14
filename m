Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYCNCXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYCNCXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYCNCX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:23:29 -0400
Received: from phunq.net ([64.81.85.152]:44642 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751927AbYCNCX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:23:28 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 18:23:14 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803131214.40321.phillips@phunq.net> <20080313162711.3d483e6c@cuia.boston.redhat.com>
In-Reply-To: <20080313162711.3d483e6c@cuia.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131923.14840.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 13:27, Rik van Riel wrote:
> On Thu, 13 Mar 2008 11:14:39 -0800
> Daniel Phillips <phillips@phunq.net> wrote:
> 
> > Scream is an exaggeration, and FUD only applies to somebody who
> > consistently overlooks the primary proposition in this design: that the
> > battery backed power supply, computer hardware and Linux are reliable
> > enough to entrust your data to them. 
> 
> That's a reasonable enough assumption, to anyone who has never dealt
> with software before, or whose data is just not important.
> 
> People who have dealt with computers for longer will know that anything
> can fail at any time, and usually does unexpectedly and at bad moments.
> 
> Some defensive programming to deal with random failures could make your
> project appealing to a lot more people than it would appeal to in its
> current state.
 
In its current state it has bugs and so should appeal only to
programmers who like to work with cutting edge stuff.

So long as you keep insisting it has to have some kind of slow
transactional sync to disk in order to be reliable enough for
enterprise use, I have to leave you in my FUD filter.  Did you
read Ric's post where he mentions the UPS in some EMS products?
Ask yourself, what is the UPS for?  Then ask yourself if EMC
makes billions of dollars selling those things to enterprise
clients.

Daniel
