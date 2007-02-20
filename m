Return-Path: <linux-kernel-owner+w=401wt.eu-S964920AbXBTIAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920AbXBTIAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 03:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964886AbXBTIAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 03:00:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964920AbXBTIAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 03:00:14 -0500
Date: Tue, 20 Feb 2007 08:00:12 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch] freevxfs: possible null pointer dereference fix
Message-ID: <20070220080012.GA24699@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dmitriy Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org
References: <87r6slz2en.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6slz2en.fsf@sw.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 10:58:08AM +0300, Dmitriy Monakhov wrote:
> sb_read may return NULL, so let's explicitly check it.
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>

Ok.

