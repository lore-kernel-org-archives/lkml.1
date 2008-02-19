Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYBSTrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYBSTrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYBSTrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:47:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYBSTrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:47:23 -0500
Date: Tue, 19 Feb 2008 13:47:02 -0600
From: David Teigland <teigland@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: pcaulfie@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make dlm_print_rsb() static
Message-ID: <20080219194702.GA5411@redhat.com>
References: <20080213212938.GG3383@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213212938.GG3383@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:29:38PM +0200, Adrian Bunk wrote:
> dlm_print_rsb() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, added to dlm.git.
Dave

