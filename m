Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXLWMJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXLWMJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXLWMJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:09:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57499 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXLWMJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:09:30 -0500
Date: Sun, 23 Dec 2007 12:09:28 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/24] udf: convert UDF_SB_NUMPARTS macro to
	udf_sb_num_parts function
Message-ID: <20071223120928.GD18629@infradead.org>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-6-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198374674-12128-6-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same comment applies to this one.  And probably the following patches
aswell so I'm not going to comment on this issue for them.

