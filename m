Return-Path: <linux-kernel-owner+w=401wt.eu-S1763226AbYEAQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763226AbYEAQEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYEAQEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:04:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18215 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYEAQEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:04:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Btrfs v0.14 Released
Date: Thu, 1 May 2008 12:04:20 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200804291601.32945.chris.mason@oracle.com>
In-Reply-To: <200804291601.32945.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011204.20847.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Chris Mason wrote:
> Hello everyone,
>
> Btrfs v0.14 is now available for download.  Please note the disk format has
> changed, and it is not compatible with older versions of Btrfs.
>
> For downloads and documention, please see the Btrfs project page:
>
> http://btrfs.wiki.kernel.org
>

Hello everyone,

I've rolled up some fixes for older kernels and fixed an uninitialized 
variables in btrfs-progs that could cause an oops on mount.  I'll wait a few 
days to see if other bug reports come in and cut a 0.15 with any other 
critical fixes.

Until then, you can find download information on the important fixes so far:

http://btrfs.wiki.kernel.org/index.php/Hot_Fixes

-chris
