Return-Path: <linux-kernel-owner+w=401wt.eu-S934789AbXHLXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbXHLXPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 19:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964813AbXHLXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 19:15:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42684 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbXHLXPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 19:15:20 -0400
Message-ID: <46BF9549.3040808@novell.com>
Date: Sun, 12 Aug 2007 18:18:33 -0500
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Kyle Moffett <mrmacman_g4@mac.com>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
References: <255628.7187.qm@web36607.mail.mud.yahoo.com>
In-Reply-To: <255628.7187.qm@web36607.mail.mud.yahoo.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> I respect the design decisions that SELinux has made regarding
> granularity without agreeing with them myself. 
>   
It isn't even an exclusive decision: both design points can be "right",
but aimed at different use cases. Which is why LSM exists, so users can
decide on an appropriate mechanism.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

