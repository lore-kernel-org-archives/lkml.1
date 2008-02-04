Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYBDCz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYBDCz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYBDCzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:55:51 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:56218 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753723AbYBDCzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:55:50 -0500
Date: Mon, 4 Feb 2008 11:54:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [SH] remove unneeded cast
Message-ID: <20080204025453.GA24901@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-sh@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20080202230347.a126a143.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202230347.a126a143.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 11:03:47PM +1100, Stephen Rothwell wrote:
> now that platform_device_register_simple() takes a "const chat *".
> 
Presumably you mean 'const char *'. Also, in the future, please don't use
a subject purposely crafted to thwart git-am. Trivial patches are enough
of a nuisance without having to do things manually. I've applied it by
hand this time, grudgingly.
