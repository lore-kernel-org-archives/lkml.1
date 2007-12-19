Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXLSOYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXLSOYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXLSOX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:23:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60767 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbXLSOXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:23:55 -0500
Date: Wed, 19 Dec 2007 14:23:51 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Mark Lord <lkml@rtr.ca>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
Message-ID: <20071219142351.GI8181@ftp.linux.org.uk>
References: <9BTqk-2ck-31@gated-at.bofh.it> <9BTJN-2Sv-21@gated-at.bofh.it> <9BTTr-35L-13@gated-at.bofh.it> <E1J4zCp-0003fj-5I@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J4zCp-0003fj-5I@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 02:43:26PM +0100, Bodo Eggert wrote:

> Since nobody knows about this "security boundary" and everybody knows about
> the annoying "can't link across bind-mountpoints bug",

... how about teaching people to RTFM?  Starting, perhaps, with man 2 link?
