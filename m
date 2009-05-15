Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbZEOEsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbZEOEsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZEOEsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:48:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZEOEsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:48:40 -0400
Message-ID: <4A0CF422.7070105@novell.com>
Date: Fri, 15 May 2009 13:48:34 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>	<4A0C4528.90608@novell.com>	<4A0CE8C6.4020102@novell.com> <20090514.213636.109200056.davem@davemloft.net>
In-Reply-To: <20090514.213636.109200056.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> You might want to drop linux-kernel-owner from the CC:, I already
> get enough copies :-)

Hehe.. Where did that come from?  Sorry about that.  :-)

-- 
tejun
