Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYCPXn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYCPXn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYCPXnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:43:51 -0400
Received: from phunq.net ([64.81.85.152]:55769 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752609AbYCPXnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:43:50 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 15:43:36 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803161538.06282.phillips@phunq.net> <m31w6a8dxb.fsf@maximus.localdomain>
In-Reply-To: <m31w6a8dxb.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161643.37310.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008 16:08, Krzysztof Halasa wrote:
> Daniel Phillips <phillips@phunq.net> writes:
> >> It could, in a bit different location maybe, but it isn't a substitute
> >> for ordered writes.
> >
> > How so?
> 
> Not sure if I understand the question correctly but obviously a pair
> (mirror) of servers running "dangerous" ramback would survive a crash
> of one machine and we could practically eliminate the probability of
> both (all) machines crashing simultaneously. However, there are
> cheaper ways to achieve similar performance and even better
> reliability - including those battery-backed (RAI)Disk controllers.

OK, so we are only searching for the cheapest way to achieve these
kinds of speeds, for some given uptime and risk level requirements.
That is a really interesting subject, but can we please leave it for a
while so I can get some work done on the code itself?

Thanks,

Daniel
