Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbXGKGjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbXGKGjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXGKGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:39:38 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:7777 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbXGKGjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:39:37 -0400
Message-ID: <46947B06.8030605@openvz.org>
Date: Wed, 11 Jul 2007 10:39:02 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org> <20070711011652.GV11166@waste.org>
In-Reply-To: <20070711011652.GV11166@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, Jul 06, 2007 at 12:01:59PM +0400, Pavel Emelianov wrote:
>> This is "submition for inclusion" of hierarchical, not kconfig
>> configurable, zero overheaded ;) pid namespaces.
> 
> How big is it?

Summary: 50 files changed, 877 insertions, 241 deletions. Besides,
each patch has a diffstat output in the letter.

> Do I want it on my cell phone or on my wireless router?
> 

I do not know, but those who do not need the namespaces at
all won't even notice its presence. I tried to do such.

Pavel.
