Return-Path: <linux-kernel-owner+w=401wt.eu-S934256AbZKXV0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256AbZKXV0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934206AbZKXV0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:26:38 -0500
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:42288 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933537AbZKXV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:26:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SqqFl9T6tlTbhfnPTktLsJK0EqeUJF4Zb1ez2gscRq1ixSCRX5F9a6gGgA1AA1m29AteNY0O7haJA+m25kRD8MhxDl0J15eO3tjMj1emhvviSh1bPST4PJSKEb8TONUo;
Date: Tue, 24 Nov 2009 13:26:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pci related patches 11-21-2009
Message-ID: <20091124132635.5fbe553c@jbarnes-piketon>
In-Reply-To: <4B07A658.8080709@kernel.org>
References: <4B07A658.8080709@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009 00:35:36 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> please check several patches from
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git
> for-pci
> 
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=shortlog;h=refs/heads/for-pci

The DMAR stuff can just go through the DMAR tree.

I don't see the two debug output patches on linux-pci, did you post
them there?

I commented on one of the resource patches, I'll check the other two
(long standing leaf release and pciehp) ones again; I mainly want a
bunch of tested-bys for those.

The x86_pci_rootbus one looks ok I think, I'll see about applying that
today.

-- 
Jesse Barnes, Intel Open Source Technology Center
