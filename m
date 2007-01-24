Return-Path: <linux-kernel-owner+w=401wt.eu-S1750910AbXAXQGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbXAXQGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXAXQGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:06:33 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:53987 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbXAXQGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:06:32 -0500
Date: Wed, 24 Jan 2007 11:06:31 -0500
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gd@spherenet.de, petero2@telia.com, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, Uwe Bugla <uwe.bugla@gmx.de>,
       alan@lxorguk.ukuu.org.uk, Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ttb@tentacle.dhs.org,
       rml@novell.com, Livio Soares <livio@eecg.toronto.edu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Malte Schr??der <MalteSch@gmx.de>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com,
       Sami Farin <7atbggg02@sneakemail.com>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com, takada <takada@mbf.nifty.com>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
Message-ID: <20070124160631.GE7582@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org> <20070124154725.GK17836@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124154725.GK17836@stusta.de>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 04:47:25PM +0100, Adrian Bunk wrote:
> Subject    : fix geode_configure()
> References : http://lkml.org/lkml/2007/1/9/216
> Submitter  : Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> Caused-By  : takada <takada@mbf.nifty.com>
>              commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
> Handled-By : takada <takada@mbf.nifty.com>
>              Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> Status     : patches are being discussed

I wouldn't call this a regression.  It appears to go way back.  I also
didn't find it, I just commented on it since it does affect the platform
I work on.

--
Len Sorensen
