Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYCMTil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYCMTil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYCMTid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:38:33 -0400
Received: from phunq.net ([64.81.85.152]:36389 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752000AbYCMTid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:38:33 -0400
From: Daniel Phillips <phillips@phunq.net>
To: ric@emc.com
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 11:38:15 -0800
User-Agent: KMail/1.9.5
Cc: Lars Marowsky-Bree <lmb@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803131202.48135.phillips@phunq.net> <47D97C9E.303@emc.com>
In-Reply-To: <47D97C9E.303@emc.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131238.16672.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 12:12, Ric Wheeler wrote:
> > Right, so Linux has gotten to the point where it competes with purpose-
> > built embedded software in reliability.  Not quite there, but close
> > enough for mission-critical.
> 
> This is our case, but we have been working for quite a while to enhance 
> the reliability of the io stack & file systems. It also helps to be very 
> careful to select hardware components with mature, open source & 
> natively integrated drivers ;-)

A word to the wise indeed.  Well I would never suggest that we can rest
on our laurels as far as Linux reliability in concerned, only that it is
already very reliable or you certainly would not ship products based on
it.

Daniel
