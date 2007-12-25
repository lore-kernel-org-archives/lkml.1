Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbXLYLyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbXLYLyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 06:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbXLYLyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 06:54:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33762 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbXLYLym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 06:54:42 -0500
Date: Tue, 25 Dec 2007 11:54:38 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] udf: remove some ugly macros
Message-ID: <20071225115438.GA8296@infradead.org>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com> <1198455022-27674-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198455022-27674-3-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks generally good, but it would be nice if you could avoid
introducing new overly long lines.  Then again this really won't be
noticed in udf anyway and it looks like you plan to clean it up later
anyway.

(in case it wasn;'t clear count this as an ack from me)

