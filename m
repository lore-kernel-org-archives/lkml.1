Return-Path: <linux-kernel-owner+w=401wt.eu-S965563AbXAWWLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563AbXAWWLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbXAWWLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:11:48 -0500
Received: from 1wt.eu ([62.212.114.60]:2148 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbXAWWA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:57 -0500
Date: Tue, 23 Jan 2007 23:00:40 +0100
From: Willy Tarreau <w@1wt.eu>
To: dann frazier <dannf@dannf.org>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       Santiago Garcia Mantinan <manty@debian.org>,
       linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: problems with latest smbfs changes on 2.4.34 and security backports
Message-ID: <20070123220040.GA14123@1wt.eu>
References: <20070117100030.GA11251@clandestino.aytolacoruna.es> <20070117215519.GX24090@1wt.eu> <20070119010040.GR16053@colo> <20070120010544.GY26210@colo> <t1r7r2thimh3gpuhtfc9l3aehjdd6dqkp8@4ax.com> <20070121230321.GC2480@1wt.eu> <lpu7r2lbtpm5cui8v1qpuj2fb5k3vs6f4n@4ax.com> <20070122181942.GJ28073@colo> <20070123054258.GA10301@1wt.eu> <20070123211256.GB26310@colo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123211256.GB26310@colo>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 02:12:57PM -0700, dann frazier wrote:
> Users have reported a symlink issue with my recent smbfs backport.
> Turns out my backport overlooked a second 2.6 patch w/ the fix:
>  http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=419e7b76CdrmRG_NZ8LKj9DUUBGu1w

Perfect. Patch queued.
Thanks for your investigatinos, Dann.

Cheers,
Willy

