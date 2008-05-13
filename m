Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYEMNcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYEMNcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYEMNcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:32:00 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56806 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100AbYEMNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:31:59 -0400
Date: Tue, 13 May 2008 09:31:58 -0400
To: Donald Douwsma <donaldd@sgi.com>
Cc: Georgi Chorbadzhiyski <gf@unixsol.org>, xfs@oss.sgi.com,
       jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
Message-ID: <20080513133158.GA7579@csclub.uwaterloo.ca>
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48292742.8090409@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 03:29:38PM +1000, Donald Douwsma wrote:
> Your distro is building all of these modules into the kernel.
> 	CONFIG_XFS_FS=y
> 	CONFIG_JFS_FS=y
> 	CONFIG_GFS2_FS=y
> 
> This isnt exactly standard practice, normally they'd be set to =m and only
> used if required to mount a filesystem. You may want to ask the slackware
> people why they chose to do this for their hugexxx.s kernels.

Because they have always done it that way so it has to be right? :)

-- 
Len Sorensen
