Return-Path: <linux-kernel-owner+w=401wt.eu-S933961AbYCEXRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961AbYCEXRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbYCEXRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:17:15 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2363 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920AbYCEXRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:17:14 -0500
Date: Thu, 6 Mar 2008 00:17:12 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Michael Matz <matz@suse.de>
Cc: Joe Buck <Joe.Buck@synopsys.COM>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
Message-ID: <20080305231712.GC2649@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Michael Matz <matz@suse.de>, Joe Buck <Joe.Buck@synopsys.COM>,
	Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	gcc@gcc.gnu.org
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <Pine.LNX.4.64.0803052241170.20583@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803052241170.20583@wotan.suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 10:43:33PM +0100, Michael Matz wrote:
> FWIW I don't think it's a release blocker for 4.3.0.  The error is arcane 
> and happens seldomly if at all.  And only on unfixed kernels.  A program 
> needs to do std explicitely, which most don't do _and_ get hit by a signal 
> while begin in a std region.  This happens so seldom that it didn't occur 
> in building the next openSuSE 11.0, and it continually builds packages 
> with 4.3 since months.

How would you know whether it has happened?

  OG.
