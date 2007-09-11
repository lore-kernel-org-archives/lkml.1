Return-Path: <linux-kernel-owner+w=401wt.eu-S965015AbXIKTCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015AbXIKTCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933714AbXIKTAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:00:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621AbXIKTAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:00:21 -0400
Message-ID: <46E6E599.8030508@redhat.com>
Date: Tue, 11 Sep 2007 14:59:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND 2][PATCH 0/4] Virtual Machine Time Accounting
References: <46E550D7.6090805@bull.net> <20070910194143.GA6052@elte.hu> <46E66228.3010901@bull.net>
In-Reply-To: <46E66228.3010901@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:

> And as values are read with a sscanf() by procps, I think adding a field at the
> end of the  line is not a problem.

It's not.  At the time iowait was introduced I verified this
in procps.

-- 
All Rights Reversed
