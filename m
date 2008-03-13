Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYCMGvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYCMGvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYCMGvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:51:07 -0400
Received: from phunq.net ([64.81.85.152]:41127 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751480AbYCMGvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:51:07 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 22:50:55 -0800
User-Agent: KMail/1.9.5
Cc: Chris Friesen <cfriesen@nortel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803122317.24849.phillips@phunq.net> <47D8C9E8.6020908@davidnewall.com>
In-Reply-To: <47D8C9E8.6020908@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122350.56811.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 23:30, David Newall wrote:
> Daniel Phillips wrote:
> >> Your idea seems predicated on throwing large amounts of RAM at the
> >> problem.  What I want to know is this: Is it really 25 times faster than
> >> ext3 with an equally huge buffer cache?
> >
> > Yes.
> 
> Well, that sounds convincing.  Not.  You know this how?

By measuring it.  time untar -xf linux-2.2.26.tar; time sync

Daniel
