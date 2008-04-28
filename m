Return-Path: <linux-kernel-owner+w=401wt.eu-S965669AbYD1Uvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965669AbYD1Uvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933022AbYD1Uvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:51:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56113 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765989AbYD1Uvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:51:40 -0400
Date: Mon, 28 Apr 2008 15:51:39 -0500
From: Paul Jackson <pj@sgi.com>
To: Rogan Dawes <lists@dawes.za.net>
Cc: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: Why these dot chars in scripts/checkpatch.pl?
Message-Id: <20080428155139.d89e47d2.pj@sgi.com>
In-Reply-To: <481637D7.8090000@dawes.za.net>
References: <20080428153122.a94d21ba.pj@sgi.com>
	<481637D7.8090000@dawes.za.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogan wrote:
> Perhaps it is because checkpatch.pl is supposed to check *patches*, 
> which are typically indented by one character (+- )?

You're a genius.  It's an honor to be of the same species.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
