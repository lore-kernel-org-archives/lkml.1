Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZGBW5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZGBW5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZGBW46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:56:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:34305 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbZGBW45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:56:57 -0400
Date: Fri, 3 Jul 2009 08:56:59 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] SElinux: Fix some typos.
In-Reply-To: <1246556775-8942-2-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LRH.2.00.0907030850500.10242@tundra.namei.org>
References: <1246556775-8942-1-git-send-email-justinmattock@gmail.com> <1246556775-8942-2-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009, Justin P. Mattock wrote:

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> Fix some typos in some comments.

> -/* The file system's label must be initialized prior to use. */
> +/* The filesystems label must be initialized prior to use. */

Your adding grammertical error's.

> -	 * Note that the setting of hard limits (even to lower them) can be
> +	 * Note: That the setting of hard limits (even to lower them) can be

Please get this patch reviewed by an English speaker.

>   * Description:
>   * Call the NetLabel mechanism to get the security attributes of the given
> - * packet and use those attributes to determine the correct context/SID to
> - * assign to the packet.  Returns zero on success, negative values on failure.
> + * packet and use those attributes to determine the correct context/SID to be
> + * assigned to the packet.  Returns zero on success, negative values on failure.

Eschew the active voice?


- James
-- 
James Morris
<jmorris@namei.org>
