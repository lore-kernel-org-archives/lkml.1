Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZEYNZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZEYNZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZEYNZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:25:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZEYNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:25:08 -0400
Message-ID: <4A1A9C35.8040309@suse.cz>
Date: Mon, 25 May 2009 15:25:09 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kbuild: add generic --set option to scripts/config
References: <cover.1243255664.git.mmarek@suse.cz> <20090525125550.GD12943@sepie.suse.cz> <20090525131308.GA846@one.firstfloor.org>
In-Reply-To: <20090525131308.GA846@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen napsal(a):
>> -	--module|-m option      Turn option into a module
>> -	--state|-s option       Print state of option (n,y,m,undef)
>> +	--module|-m option   Turn option into a module
>> +	--set option value   Set option to arbitrary value
> 
> --set seems like fluff to me, it's redundant compared to what was there
> before.

It could be useful for setting integer options. I personally don't need
that, I just added it for completeness. I can remove it if you don't
like it.

Michal
