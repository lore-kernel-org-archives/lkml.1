Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbYA2N3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbYA2N3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932391AbYA2N3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:29:06 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36300 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbYA2N3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:29:03 -0500
Date: Tue, 29 Jan 2008 13:28:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@sister.site
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 24/26] mount options: fix tmpfs
In-Reply-To: <E1JJSMA-00009M-4h@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0801291326360.4303@sister.site>
References: <20080124193341.166753833@szeredi.hu> <20080124193454.408283578@szeredi.hu>
 <Pine.LNX.4.64.0801280534370.15609@sister.site> <E1JJSMA-00009M-4h@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Miklos Szeredi wrote:
> 
> I'll add functions for calculating the default max values, so the
> calculations won't accidentally become different for the
> initialization and the option showing.

Excellent.

> > If you agree with the version below, please take it into your collection
> > and insert your Signed-off-by.  I should admit, I've not yet tested how
> > the NUMA policies look: you'll hear from me again tomorrow morning if
> > those turn out to wrong.
> 
> OK, I'll send this to Andrew.  Maybe I'll wait until tomorrow to hear
> if it's working on NUMA.

I've just now checked: the NUMA options are showing fine.

Thanks,
Hugh
