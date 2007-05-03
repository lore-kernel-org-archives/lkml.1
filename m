Return-Path: <linux-kernel-owner+w=401wt.eu-S1162137AbXECPmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162137AbXECPmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946187AbXECPmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:42:19 -0400
Received: from lazybastard.de ([212.112.238.170]:41156 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162137AbXECPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:42:17 -0400
Date: Thu, 3 May 2007 17:37:53 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Erik Mouw <mouw@nl.linux.org>
Cc: Hugh Dickins <hugh@veritas.com>, Phillip Susi <psusi@cfl.rr.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Execute in place
Message-ID: <20070503153753.GA29755@lazybastard.org>
References: <4637B751.1080907@cfl.rr.com> <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com> <20070503113822.GA27404@gateway.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070503113822.GA27404@gateway.home>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 13:38:22 +0200, Erik Mouw wrote:
> On Wed, May 02, 2007 at 03:04:44PM +0100, Hugh Dickins wrote:
> > 
> > Only ext2 supports it today: see Documentation/filesystems/xip.txt
> 
> IIRC JFFS2 also supports XIP.

Definitely not.  AXFS does, if you want to consider out-of-tree patches.

Jörn

-- 
Fools ignore complexity.  Pragmatists suffer it.
Some can avoid it.  Geniuses remove it.
-- Perlis's Programming Proverb #58, SIGPLAN Notices, Sept.  1982
