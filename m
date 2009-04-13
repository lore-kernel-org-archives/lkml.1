Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZDMVp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZDMVp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZDMVpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:45:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbZDMVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:45:09 -0400
Date: Mon, 13 Apr 2009 14:33:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Valdis.Kletnieks@vt.edu
cc: "Serge E. Hallyn" <serue@us.ibm.com>, mtk.manpages@gmail.com,
       Stephen Smalley <sds@epoch.ncsc.mil>, Andrew Morgan <morgan@kernel.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Igor Zhbanov <izh1979@gmail.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, stable@kernel.org,
       linux-api@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] add some long-missing capabilities to fs_mask
In-Reply-To: <13502.1239656608@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.2.00.0904131433270.26713@localhost.localdomain>
References: <20090413145614.GA15342@us.ibm.com> <13502.1239656608@turing-police.cc.vt.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Apr 2009, Valdis.Kletnieks@vt.edu wrote:
> 
> Wow. How did this manage to stay un-noticed for this long?

Because nobody uses capabilities?

		Linus
