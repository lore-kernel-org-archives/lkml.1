Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYAHOJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYAHOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYAHOJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:09:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44250 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYAHOJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:09:11 -0500
Date: Tue, 8 Jan 2008 14:09:02 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #6 02/21] Add struct vfsmount to struct task_struct.
Message-ID: <20080108140902.GA12238@infradead.org>
References: <20080108094903.484613061@nttdata.co.jp> <20080108094956.610620186@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108094956.610620186@nttdata.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just FYI:  A NACK to such an addition doesn't simply go away by
ignoring it.
