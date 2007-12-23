Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbXLWMEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbXLWMEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXLWMEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:04:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39420 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbXLWME3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:04:29 -0500
Date: Sun, 23 Dec 2007 12:04:26 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/24] udf: rename UDF_SB to udf_sb
Message-ID: <20071223120426.GA18629@infradead.org>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198374674-12128-3-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 02:50:52AM +0100, marcin.slusarz@gmail.com wrote:
> rename UDF_SB function to udf_sb

FOO_SB is a convention used by most filesystems, so I don't really see
any point in changing it.

