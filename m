Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYCaLks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYCaLks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYCaLkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:40:42 -0400
Received: from phunq.net ([64.81.85.152]:51906 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753098AbYCaLkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:40:42 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 31 Mar 2008 04:40:32 -0700
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <47DFBD99.2080501@davidnewall.com> <alpine.DEB.1.00.0803180933230.21250@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803180933230.21250@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803310440.33019.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008 09:36, david@lang.hm wrote:
> P.S. 8xPCI-e slots are only able to do 2GB/s of data transfer, in an 
> earlier post Daniel claimed that you needed 3GB/s of disk to mirror to the 
> disk, so the scenerio listed above looses 1/3 of it's performance compared 
> to what was being claimed earlier.

Each Violin 1010 has two 8xPCI-e interfaces.

Daniel
