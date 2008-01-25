Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYAYJyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYAYJyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYAYJy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:54:27 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49594 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbYAYJy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:54:26 -0500
To: gregkh@suse.de
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080124220126.GA6185@suse.de> (message from Greg KH on Thu, 24
	Jan 2008 14:01:26 -0800)
Subject: Re: [patch 26/26] mount options: fix usbfs
References: <20080124193341.166753833@szeredi.hu> <20080124193457.628524720@szeredi.hu> <20080124220126.GA6185@suse.de>
Message-Id: <E1JILGO-0001QN-Qw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 10:54:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add a .show_options super operation to usbfs.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> Looks good to me.  Do you want to take this through your tree, as it is
> dependant on other changes, or do you want me to take this through the
> USB tree?  Whatever is easier for you is fine for me.

Please take it, it should be independent of the other changes.

Thanks,
Miklos
