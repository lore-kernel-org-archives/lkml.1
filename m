Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYDPNlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYDPNlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYDPNll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:41:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbYDPNll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:41:41 -0400
Date: Wed, 16 Apr 2008 14:41:29 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [2.6 patch] make dm_{, un}register_dirty_log_type() static
Message-ID: <20080416134129.GH18935@agk.fab.redhat.com>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20080330232824.GV28445@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330232824.GV28445@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 02:28:24AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global dm_{,un}register_dirty_log_type() 
> static.
 
(Patch superceded by other interface changes.)

Actively used in an area of out-of-tree development which should move in-tree
when it's ready.

Alasdair
-- 
agk@redhat.com
