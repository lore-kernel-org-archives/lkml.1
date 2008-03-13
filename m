Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbYCMGOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbYCMGOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCMGOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:14:33 -0400
Received: from phunq.net ([64.81.85.152]:48704 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbYCMGOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:14:32 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 22:14:16 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803121029.54108.phillips@phunq.net> <47D8BE08.6040800@davidnewall.com>
In-Reply-To: <47D8BE08.6040800@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122314.18244.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 22:39, David Newall wrote:
> Daniel Phillips wrote:
> > Particularly about Ext2/Ext3, which does recover well from random damage.
> > My experience.
> 
> By "recover well", you must mean "loses massive swabs of data, leaving
> the system unbootable and with enormous numbers of user files missing." 
> My experience.
> 
> Expecting fsck to cover for missed writes is stupid.

Whatever it can get off the disk it gets.  It does a good job.  If you
don't think so, then don't tell me, tell Ted.

Daniel
