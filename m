Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZKPVJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZKPVJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZKPVJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:09:38 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:37503 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbZKPVJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:09:38 -0500
Date: Mon, 16 Nov 2009 14:09:41 -0700
From: Alex Chiang <achiang@hp.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-11-13-19-59 uploaded
Message-ID: <20091116210941.GA2622@ldl.fc.hp.com>
References: <200911140403.nAE43CN1016851@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911140403.nAE43CN1016851@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

* akpm@linux-foundation.org <akpm@linux-foundation.org>:
> The mm-of-the-moment snapshot 2009-11-13-19-59 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.32-rc7:

Many of the patches have dropped their subject lines. I realize
that you can get the subject of the patch from the patch name,
but if one is using the git tree, then looking at the git log,
you see things like:

	commit 7f97d096be78d5a8d6bf2efc28fe3efba21e47f0
	Author: Andrew Morton <akpm@linux-foundation.org>
	Date:   Mon Nov 9 20:59:36 2009 +0100

	    fed up with those stupid warnings
	    
	    
	    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

And there's no real good way to know that it came from
undeprecate-pci_find_device.patch.

Would it be reasonable of me to request that your scripts stick
the subject of the mail into the patch description field? That
would greatly enhance the useability of the git version of mmotm.

Thanks,
/ac

