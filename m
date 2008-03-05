Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbYCEXOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbYCEXOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933348AbYCEXMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:12:43 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:4576 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349AbYCEXMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:12:40 -0500
Date: Thu, 6 Mar 2008 00:12:38 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Michael Matz <matz@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       richard.guenther@gmail.com, Joe.Buck@synopsys.com, hubicka@ucw.cz,
       aurelien@aurel32.net, linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
Message-ID: <20080305231238.GA2649@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Michael Matz <matz@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
	David Miller <davem@davemloft.net>, richard.guenther@gmail.com,
	Joe.Buck@synopsys.com, hubicka@ucw.cz, aurelien@aurel32.net,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
References: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com> <20080305.141622.80343656.davem@davemloft.net> <Pine.LNX.4.64.0803052341330.20583@wotan.suse.de> <47CF25A5.5060709@zytor.com> <Pine.LNX.4.64.0803060006520.20583@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803060006520.20583@wotan.suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:07:39AM +0100, Michael Matz wrote:
> For security problems I prefer fixes over work-arounds.  The fix lies in 
> the kernel, the work-around in gcc.

Incorrect.  The bugs are in the ABI documentation and in gcc, and the
fixes should be done there.  Doing it in the kernel is the workaround.

  OG.

