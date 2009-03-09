Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZCII3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZCII3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZCII3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:29:03 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:48695 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZCII3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:29:01 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [Aufs 01/25] aufs documents 
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090309054842.GA14122@uranus.ravnborg.org>
References: <1236569118-3750-1-git-send-email-hooanon05@yahoo.co.jp> <1236569118-3750-2-git-send-email-hooanon05@yahoo.co.jp> <20090309054842.GA14122@uranus.ravnborg.org>
Date: Mon, 09 Mar 2009 17:28:55 +0900
Message-ID: <9898.1236587335@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you very much for you comments!

Sam Ravnborg:
> Documention seems impressive!
> But your changelogs are in the contrary very sparse.

In initial commits, my poor English has less issues to write...


> >  fs/Kconfig                                         |    1 +
> >  fs/Makefile                                        |    1 +
> The changes in the above files breaks bisectability.
> You just broke "make oldconfig".
	:::
> The changes to files outside fs/aufs2 needs to be justified in your changelog.
> And they do not belong in this patch.

They are all my fault in GIT work.
I will post a new patchset after receiving other comments or in a week.


J. R. Okajima
