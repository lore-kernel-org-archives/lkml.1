Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZIAIv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZIAIv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZIAIvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:25 -0400
Received: from tundra.namei.org ([65.99.196.166]:38397 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZIAIvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:24 -0400
Date: Tue, 1 Sep 2009 18:51:12 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: akpm@linux-foundation.org, mingo@redhat.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 2/6] SECURITY: add task_struct to setrlimit
In-Reply-To: <1251744974-29398-2-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LRH.2.00.0909011850580.28277@tundra.namei.org>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com> <1251744974-29398-2-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Jiri Slaby wrote:

> Add task_struct to task_setrlimit of security_operations to be able to set
> rlimit of different task than current.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@parisplace.org>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
