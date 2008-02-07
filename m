Return-Path: <linux-kernel-owner+w=401wt.eu-S935488AbYBGXfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488AbYBGXfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761931AbYBGXez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:34:55 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:37855 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbYBGXey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:34:54 -0500
Date: Thu, 7 Feb 2008 18:34:52 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Adrian Bunk <bunk@kernel.org>,
       kyle@parisc-linux.org, matthew@wil.cx, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: parisc compile error
Message-ID: <20080207233452.GB11653@phobos.i.cabal.ca>
References: <20080207231232.GF7198@cs181133002.pp.htv.fi> <20080207232015.GA11653@phobos.i.cabal.ca> <Pine.LNX.4.64.0802071532430.3845@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802071532430.3845@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 03:33:07PM -0800, Christoph Lameter wrote:
> On Thu, 7 Feb 2008, Kyle McMartin wrote:
> 
> > yes, it's in my batch of fixes.
> 
> <big sigh of relief> So I do not have to worry about it?
> 

haha no. i don't expect people to have to untangle the mess of includes
that is <asm-parisc/*.h> :)

cheers, kyle
