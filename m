Return-Path: <linux-kernel-owner+w=401wt.eu-S1764067AbYHFVd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764067AbYHFVd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761762AbYHFVYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:24:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:50047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760922AbYHFVYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:24:32 -0400
Date: Wed, 6 Aug 2008 14:24:21 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2/cluster/netdebug.c: fix warning
Message-ID: <20080806212421.GX28014@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <20080805201036.GC17320@orion> <20080805202948.GL22600@mail.oracle.com> <20080805205041.GD17320@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805205041.GD17320@orion>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:50:41AM +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> ocfs2/cluster/netdebug.c: fix warning
> 
> fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
>      type 'long unsigned int', but argument 17 has type 'suseconds_t'


Ok, this is in ocfs2.git now.
	--Mark

--
Mark Fasheh
