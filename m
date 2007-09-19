Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXIST2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXIST2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbXIST2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:28:11 -0400
Received: from ns1.suse.de ([195.135.220.2]:48469 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbXIST2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:28:10 -0400
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>,
       john cooper <john.cooper@third-harmonic.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 21:28:07 +0200
In-Reply-To: <46F1645D.9050406@am.sony.com>
Message-ID: <p73fy1av4jc.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird <tim.bird@am.sony.com> writes:


> Recently, the CE Linux forum has been working to revive the
> Linux-tiny project.  At OLS, I asked for interested parties
> to volunteer to become the new maintainer for the Linux-tiny patchset.

Not sure what the point is of a separate patchkit. If it's a reasonable
patch it should just be put into mainline. And hopefully all the patches
will be reasonable.

-Andi
