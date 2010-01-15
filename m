Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab0AOSye (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641Ab0AOSyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:54:33 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:56336 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753718Ab0AOSyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:54:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mMUHcEa15etkrwl9U6xqHva8PX+v/bV2ZJ90ybHxC3PmTAAAQNeJcb81CmQfhjRT6ob7wf6G1OBrQRt5SEfm3FGOtP8U1gd38qnJBG6BA/Y7mAUpJtUqdhgqLUI1PJb2;
Date: Fri, 15 Jan 2010 10:54:32 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 01/14] pci: separate pci_setup_bridge to small functions
Message-ID: <20100115105432.6f2291fd@jbarnes-piketon>
In-Reply-To: <1261522954-12591-2-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-2-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:21 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> prepare to use those small functions according to resource type later
> 
> -v2: remove pref_mem64 typo, it should be removed
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
