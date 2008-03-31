Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbYCaU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbYCaU0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYCaU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:26:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31481 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYCaU0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:26:36 -0400
Date: Mon, 31 Mar 2008 14:26:33 -0600
From: Alex Chiang <achiang@hp.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: [ANNOUNCE] Btrfs v0.13
Message-ID: <20080331202633.GA341@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802211609.50563.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802211609.50563.chris.mason@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Mason <chris.mason@oracle.com>:
> Hello everyone,
> 
> Btrfs v0.13 is now available for download from:

Hi Chris,

Following are two patches that allow btrfs-progs to build on
ia64, and prevent a SEGV when trying to do a mkfs.btrfs.

I've gotten as far as successfully creating a btrfs filesystem
(at least that's what btrfsck tells me), but haven't been able to
mount it yet, probably because of the sector size issue.

/ac

