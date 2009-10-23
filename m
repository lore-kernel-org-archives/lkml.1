Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZJWSAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZJWSAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZJWSAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:00:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:40386 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZJWSAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:00:31 -0400
Date: Fri, 23 Oct 2009 11:00:34 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag FIEMAP_EXTENT_SHARED
Message-ID: <20091023180034.GA11402@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com> <1256173509-2831-2-git-send-email-sunil.mushran@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256173509-2831-2-git-send-email-sunil.mushran@oracle.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 06:05:08PM -0700, Sunil Mushran wrote:
> Patch adds flag FIEMAP_EXTENT_SHARED to denote extents that are
> shared with other inodes.

This looks pretty sane to me. Thanks Sunil.


> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
