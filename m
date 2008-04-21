Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbYDURoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbYDURoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbYDURoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:44:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422AbYDURoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:44:00 -0400
Date: Mon, 21 Apr 2008 10:43:58 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make struct ocfs2_control_device static
Message-ID: <20080421174358.GP31299@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <20080421084926.GS26897@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421084926.GS26897@cs181133002.pp.htv.fi>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:49:26AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global struct ocfs2_control_device 
> static.

This and the following two patches are in ocfs2.git now, thanks Adrian.
	--Mark

--
Mark Fasheh
