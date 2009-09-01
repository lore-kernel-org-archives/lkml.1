Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZIAIv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZIAIv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZIAIvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:55 -0400
Received: from tundra.namei.org ([65.99.196.166]:38402 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbZIAIvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:53 -0400
Date: Tue, 1 Sep 2009 18:51:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: akpm@linux-foundation.org, mingo@redhat.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] core: add task_struct to update_rlimit_cpu
In-Reply-To: <1251744974-29398-3-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LRH.2.00.0909011851270.28277@tundra.namei.org>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com> <1251744974-29398-3-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Jiri Slaby wrote:

> Add task_struct as a parameter to update_rlimit_cpu to be able to set
> rlimit_cpu of different task than current.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
