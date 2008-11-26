Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYKZTxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYKZTxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKZTxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:53:24 -0500
Received: from mx1.suse.de ([195.135.220.2]:49567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYKZTxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:53:23 -0500
Date: Wed, 26 Nov 2008 11:53:21 -0800
From: Mark Fasheh <mfasheh@suse.com>
To: Jan Kara <jack@suse.cz>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc6-mmotm1126 - BUG in disk quota code
Message-ID: <20081126195321.GF8378@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <4270.1227716433@turing-police.cc.vt.edu> <20081126164906.GG23124@duck.suse.cz> <3893.1227721813@turing-police.cc.vt.edu> <20081126175811.GH23124@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126175811.GH23124@duck.suse.cz>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 06:58:11PM +0100, Jan Kara wrote:
>   Hmm, I've just checked and it does not seem Mark has merged the patches
> yet. I've attached the patches which fix the problem just in case you need
> to boot the machine with -mm for some other purposes.

FYI, these are merged now along with the ocfs2 fixes you sent.
	--Mark


--
Mark Fasheh
