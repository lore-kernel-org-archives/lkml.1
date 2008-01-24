Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYAXOp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYAXOp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYAXOps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:45:48 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:36254 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbYAXOps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:45:48 -0500
Date: Thu, 24 Jan 2008 09:45:47 -0500
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Tobias Winter <tobias@linuxdingsda.de>, linux-kernel@vger.kernel.org
Subject: Re: kernel bug report 2.6.24-rc8 on core2quad q6600 with debian unstable amd64
Message-ID: <20080124144547.GB16173@csclub.uwaterloo.ca>
References: <4797D86B.3060202@linuxdingsda.de> <20080123170748.36068472@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123170748.36068472@deepthought>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 05:07:48PM -0800, Stephen Hemminger wrote:
> Sounds like bad memory. Run memtest for at least 24hrs.

Or better yet take out half the ram and see what happens, then try the
other half and see if you have a bad stick.

Also check the power supply in case it is underpowered or low quality.

I don't remember how much power a Q6600 uses under full load but it is
quite a bit.

--
Len Sorensen
