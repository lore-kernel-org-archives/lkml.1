Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZEYNGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZEYNGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZEYNGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:06:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60060 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZEYNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:06:41 -0400
Date: Mon, 25 May 2009 15:13:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kbuild: add generic --set option to scripts/config
Message-ID: <20090525131308.GA846@one.firstfloor.org>
References: <cover.1243255664.git.mmarek@suse.cz> <20090525125550.GD12943@sepie.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525125550.GD12943@sepie.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	--module|-m option      Turn option into a module
> -	--state|-s option       Print state of option (n,y,m,undef)
> +	--module|-m option   Turn option into a module
> +	--set option value   Set option to arbitrary value

--set seems like fluff to me, it's redundant compared to what was there
before.

> +	--set-str option value
> +	                     Same as --set, bu quote value

But that's ok.


> +	--state|-s option    Print state of option (n,y,m,undef)

Thanks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
