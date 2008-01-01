Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYAASKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYAASKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 13:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYAASKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 13:10:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40080 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYAASKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 13:10:33 -0500
Date: Tue, 1 Jan 2008 18:10:30 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: sfrench@samba.org, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] CIFS: #if 0 mode_to_access_flags()
Message-ID: <20080101181030.GA25656@infradead.org>
References: <20080101134644.GE2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101134644.GE2360@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 03:46:44PM +0200, Adrian Bunk wrote:
> This patch #if 0's the unused mode_to_access_flags(), fixing the 
> following compile warning:

Please remove it completely instead.
