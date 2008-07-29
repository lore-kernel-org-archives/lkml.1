Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYG2NE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYG2NE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYG2NES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:04:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52175 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752876AbYG2NER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:04:17 -0400
Date: Tue, 29 Jul 2008 08:04:15 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
Message-Id: <20080729080415.409f25fc.pj@sgi.com>
In-Reply-To: <488E72BE.9070108@cn.fujitsu.com>
References: <488D332A.1030008@cn.fujitsu.com>
	<20080728010141.fbd33866.pj@sgi.com>
	<488E72BE.9070108@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Yes, but I just noticed Max removes that comment completely in his patch,
> so I guess I can leave it as it is.

Yeah - leave it as it is.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
