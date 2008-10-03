Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYJCUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYJCUs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYJCUsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:48:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42484 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYJCUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:44 -0400
Date: Fri, 3 Oct 2008 13:54:11 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: krzysztof.h1@poczta.fm
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>,
       linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] matroxfb: Support G200eV chip
Message-ID: <20081003205411.GA7632@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20081002092933.2EFC4199B267@f14.poczta.interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002092933.2EFC4199B267@f14.poczta.interia.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 11:29:33AM +0200, krzysztof.h1@poczta.fm wrote:
> > Support the Matrox G200eV chip, based on timings that I found in the
> > X.org matrox driver.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > 
> 
> Is the new chip requires some changes in handling (e.g. diffrent clock ranges/setting, etc)?
> There is nothing about timings in the patch (aside 230MHz).

As far as I could tell from the corresponding patch to Xorg there aren't
any changes needed... but so far it's only passed the smoke test and the
"it appears to work on my machine" test. :)

--D
