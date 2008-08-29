Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYH2Lv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYH2Lv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYH2LvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:51:18 -0400
Received: from lazybastard.de ([212.112.238.170]:36672 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbYH2LvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:51:18 -0400
Date: Fri, 29 Aug 2008 13:04:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: konishi.ryusuke@lab.ntt.co.jp
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Message-ID: <20080829110438.GC27647@logfs.org>
References: <20080827181904.GD1371@logfs.org> <200808290629.AA00218@capsicum.lab.ntt.co.jp> <200808291040.06917.arnd@arndb.de> <20080829.195156.31189122.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080829.195156.31189122.ryusuke@osrg.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 August 2008 19:51:56 +0900, konishi.ryusuke@lab.ntt.co.jp wrote:
> 
> Since the primary purpose of NILFS is providing continuous
> snapshotting, the GC is not necessarily designed with such requirement
> in mind.

No shame in that.  One fine day I would like to have a filesystem that
combines all the neat tricks from the half-dozen new filesystems that
are currently under development.  Until then, people will simply have to
pick which one matches their personal requirements best.

Jörn

-- 
There are three principal ways to lose money: wine, women, and engineers.
While the first two are more pleasant, the third is by far the more certain.
-- Baron Rothschild
