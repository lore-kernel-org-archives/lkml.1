Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYG2DG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYG2DG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYG2DGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:06:49 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:44715 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbYG2DGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:06:48 -0400
Date: Mon, 28 Jul 2008 23:06:47 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to
	convert
Message-ID: <20080729030647.GA11425@phobos.i.cabal.ca>
References: <20080728200500.GA14284@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728200500.GA14284@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:05:00PM +0200, Sam Ravnborg wrote:
> I am limited in time and resources at the moment but I
> would be glad to help out as time permits should there
> be any questions.
> 

Just a quick one... I moved the files on parisc, but found we're still
using include/asm-$foo/asm-offsets.h. A quick glance at Kbuild seems to
indicate so. Is this expected?

cheers, Kyle
