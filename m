Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYHLDdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYHLDdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYHLDdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:33:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42277 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211AbYHLDdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:33:44 -0400
Date: Mon, 11 Aug 2008 22:33:41 -0500
From: Paul Jackson <pj@sgi.com>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (take 4)
Message-Id: <20080811223341.cc9b4862.pj@sgi.com>
In-Reply-To: <b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com>
	<48A0B16B.2080801@qualcomm.com>
	<b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib wrote:
> One more thing Max, ...

Best not to quote an entire long message when only
a little bit of it is needed to provide context for
the reply.  It forces all readers to scan down many
pages trying to find the useful reply.

I agree with Max's reply to this ... his comment
explaining why checking dattr is not NULL looks good.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
