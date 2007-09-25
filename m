Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbXIYQj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbXIYQj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXIYQjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:39:17 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51537 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbXIYQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:39:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Remove broken netfilter binary sysctls from bridging code
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070921020554.GE31759@nineveh.local>
	<m1fy18k5ru.fsf@ebiederm.dsl.xmission.com>
	<46F7EC0A.9030506@trash.net>
	<m1641ydeqr.fsf@ebiederm.dsl.xmission.com>
	<46F91AAD.9090801@trash.net>
Date: Tue, 25 Sep 2007 10:38:24 -0600
In-Reply-To: <46F91AAD.9090801@trash.net> (Patrick McHardy's message of "Tue,
	25 Sep 2007 16:26:53 +0200")
Message-ID: <m1y7euaef3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> OK lets keep it then. Fixing the race seems overkill to me though.

Me to.

Eric

