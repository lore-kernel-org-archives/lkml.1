Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbYCEXPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbYCEXPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbYCEXNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:13:24 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:4865 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbYCEXNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:13:22 -0500
Date: Thu, 6 Mar 2008 00:13:19 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Michael Matz <matz@suse.de>, Chris Lattner <clattner@apple.com>,
       "H.Peter Anvin" <hpa@zytor.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305231319.GB2649@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Adrian Bunk <bunk@kernel.org>, Michael Matz <matz@suse.de>,
	Chris Lattner <clattner@apple.com>, "H.Peter Anvin" <hpa@zytor.com>,
	Richard Guenther <richard.guenther@gmail.com>,
	Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
	Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
	gcc@gcc.gnu.org
References: <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <20080305221303.GA937@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305221303.GA937@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:13:04AM +0200, Adrian Bunk wrote:
> Compiling older kernels with new gcc versions has never been supported.

You read the thread too fast.  It's not at all about compiling the
kernel.

  OG.
