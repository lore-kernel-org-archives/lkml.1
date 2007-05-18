Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXERWTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXERWTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXERWTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:19:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbXERWTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:19:08 -0400
Message-ID: <464E2654.1050009@redhat.com>
Date: Fri, 18 May 2007 18:19:00 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roger Heflin <rheflin@atipa.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at mm/mempool.c:210
References: <464E2365.6060003@atipa.com>
In-Reply-To: <464E2365.6060003@atipa.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Heflin wrote:
> I am getting this bug under heavy IO/NFS on 2.6.21.1.
> 
> BUG: sleeping function called from invalid context at mm/mempool.c:210
> 
> So far I have got the error I believe 3 times.
> 
Is there a backtrace?
