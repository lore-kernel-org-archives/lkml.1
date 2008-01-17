Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYAQGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYAQGnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 01:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYAQGnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 01:43:09 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:22409 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYAQGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 01:43:08 -0500
Date: Thu, 17 Jan 2008 01:43:05 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>, mingo@elte.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: remove casts
Message-ID: <20080117064305.GB4495@phobos.i.cabal.ca>
References: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr> <20080116222055.GA344@phobos.i.cabal.ca> <Pine.LNX.4.64.0801162357160.31385@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801162357160.31385@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 11:57:54PM +0100, Jan Engelhardt wrote:
> 
> On Jan 16 2008 17:20, Kyle McMartin wrote:
> >On Wed, Jan 16, 2008 at 10:15:39PM +0100, Jan Engelhardt wrote:
> >> parent a9f7faa5fd229a65747f02ab0f2d45ee35856760
> >> commit ffffffffffffffffffffffffffffffffffffffff
> >
> >^- did you just make that up? ;-)
> 
> Yes. git does not care anyway.
> 

right. the point was if you had generated a sha1 of all ones. that would
be kind of neat.
