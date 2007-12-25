Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXLYQlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXLYQlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 11:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXLYQlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 11:41:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXLYQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 11:41:14 -0500
Date: Tue, 25 Dec 2007 16:41:11 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] udf: convert UDF_SB_ALLOC_PARTMAPS macro to
	udf_sb_alloc_partition_maps function
Message-ID: <20071225164110.GA16679@infradead.org>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com> <1198455022-27674-4-git-send-email-marcin.slusarz@gmail.com> <20071225115946.GB8296@infradead.org> <20071225151314.GE24373@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071225151314.GE24373@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, thanks.
