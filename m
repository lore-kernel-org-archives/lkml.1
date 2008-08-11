Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYHKUKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYHKUKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYHKUKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:10:24 -0400
Received: from sandeen.net ([209.173.210.139]:13527 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYHKUKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:10:23 -0400
Message-ID: <48A09CA9.9080705@sandeen.net>
Date: Mon, 11 Aug 2008 15:10:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: Lock debugging noise or real problem?
References: <48A093A7.40606@tlinx.org>
In-Reply-To: <48A093A7.40606@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:

> This is a trimmed version of my Warn log (with boot indicators) since
>  the problems started.  I'm also unsure why some user-level processes seem
> to be dumping trace-backs periodically, including:
> 
> cifsopslock
> xfs_fsr (a few)

the explanation for xfs_fsr, at least, is the same as the last time you
brought it up ;)

http://lkml.org/lkml/2008/2/12/86

-Eric
