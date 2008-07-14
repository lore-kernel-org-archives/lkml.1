Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYGNIQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYGNIQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 04:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYGNIQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 04:16:21 -0400
Received: from swm.pp.se ([212.247.200.143]:58931 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbYGNIQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 04:16:21 -0400
Date: Mon, 14 Jul 2008 10:16:19 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
In-Reply-To: <20080714073035.GV29319@disturbed>
Message-ID: <alpine.DEB.1.10.0807141015010.30192@uplift.swm.pp.se>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se> <20080714073035.GV29319@disturbed>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Dave Chinner wrote:

> Can you find the file it is failing on and run 'xfs_bmap -vvp <file>' to 
> just extract the extent map outside the context of xfs_fsr?

It's run twice without any errors now, so I guess I can't reproduce it 
anymore. If it happens again, how can I find out which file is causing the 
problem? I looked at the xfs_fsr man page and it didn't say much, would it 
help if I ran it in "-v" mode?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
