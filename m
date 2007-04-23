Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXDWN6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXDWN6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbXDWN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:58:09 -0400
Received: from [70.254.190.220] ([70.254.190.220]:55956 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753873AbXDWN6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:58:07 -0400
Date: Mon, 23 Apr 2007 13:58:06 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>
Subject: Re: BUG: Null pointer dereference (2.6.21-rc7)
In-Reply-To: <20070423010032.c89e8d32.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704231356480.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
 <20070423010032.c89e8d32.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Andrew Morton wrote:
> It certainly is.  Are you able to identify an earlier kernel in which this
> didn't happen?  2.6.20?  An earlier 2.6.21-rcX?

I'll try .18 and .20 and see where that gets me - this is my first time 
trying to set up packet writing.

William Heimbigner
icxcnika@mar.tar.cc
