Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYBMVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYBMVza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765388AbYBMVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:32:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45083 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765359AbYBMVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:32:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=X5jJDq9z1brgHgtsZJ2RNnCGbkBxApaBz0SR/cIbvpw4+dkCAi4Nb7lwkZ4QXDLvw
	b9VjPlCK1s7v2j1daOT9g==
Date: Wed, 13 Feb 2008 13:32:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Adrian Bunk <bunk@kernel.org>
cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make cgroup_enable_task_cg_lists() static
In-Reply-To: <20080213213029.GF3383@cs181133002.pp.htv.fi>
Message-ID: <alpine.DEB.1.00.0802131331480.5914@chino.kir.corp.google.com>
References: <20080213213029.GF3383@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Adrian Bunk wrote:

> This patch makes the needlessly global cgroup_enable_task_cg_lists() 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
