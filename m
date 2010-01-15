Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0AOKbc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767Ab0AOKba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:31:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:44888 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0AOKba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:31:30 -0500
Date: Fri, 15 Jan 2010 11:31:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix some typo's in avc.c
In-Reply-To: <1263538998-20088-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1001151131180.30977@pobox.suse.cz>
References: <1263538998-20088-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Justin P. Mattock wrote:

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>  security/selinux/avc.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index f2dde26..3328b1f 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -337,7 +337,7 @@ static inline struct avc_node *avc_search_node(u32 ssid, u32 tsid, u16 tclass)
>   * Look up an AVC entry that is valid for the
>   * (@ssid, @tsid), interpreting the permissions
>   * based on @tclass.  If a valid AVC entry exists,
> - * then this function return the avc_node.
> + * then this function returns the avc_node.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
