Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYKEXS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYKEXS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYKEXSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:18:13 -0500
Received: from tundra.namei.org ([65.99.196.166]:45753 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbYKEXSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:18:12 -0500
Date: Thu, 6 Nov 2008 10:18:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] file capabilities: add no_file_caps switch (v4)
In-Reply-To: <20081105220852.GA1622@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0811061017360.6690@tundra.namei.org>
References: <20081105220852.GA1622@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Serge E. Hallyn wrote:

> Hi James, do you mind adding this to the security-testing tree?
> 
> (It needs the recent file-caps-always-start-with-clear-bprm-caps patch
> which is upstream but not in security-testing:next - if it's more
> convenient for you I can resend that)

I merged the tree with Linus and applied the patch to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
