Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbXBXASp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbXBXASp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXBXASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:18:45 -0500
Received: from terminus.zytor.com ([192.83.249.54]:34324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbXBXASo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:18:44 -0500
Message-ID: <45DF845B.3020602@zytor.com>
Date: Fri, 23 Feb 2007 16:18:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: dsaxena@plexity.net
CC: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow kernel to build on Cygwin
References: <20070223034343.GA3320@plexity.net>
In-Reply-To: <20070223034343.GA3320@plexity.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Deepak Saxena wrote:
> This patch contains a set of small fixes to allow the kernel to build under
> the Cygwin environment, which is unfortunately used by more people than
> one would think in the embedded world. :(
> 
> Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

I have one major problem with this patch: none of the hacks are 
commented, which invites cargo cult programming by people who needs to 
further maintain the code.

	-hpa
