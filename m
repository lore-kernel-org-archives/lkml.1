Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbXLDTW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbXLDTW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbXLDTWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:22:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53125 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbXLDTWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:22:48 -0500
Date: Tue, 4 Dec 2007 19:22:43 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       roland@redhat.com, dsmith@redhat.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] Linux Kernel Markers - Create modpost file
Message-ID: <20071204192243.GA23609@infradead.org>
References: <20071204181845.895090222@polymtl.ca> <20071204182403.319351701@polymtl.ca> <20071204111026.9f7d8ed5.akpm@linux-foundation.org> <20071204191528.GA31752@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204191528.GA31752@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:15:28PM -0500, Mathieu Desnoyers wrote:
> Yup. What I would really like is to, at least, get the API stabilised
> for 2.6.24. It that means extracting the API changes from the first
> patch, I could do it. Then we would have plenty of time to discuss the
> multiple probes support.

We don't have a stable API anyway.  No need to hurry.  The only
markers user submitted to far is my suptrace and I'll happily adjust
APIs when they happen to change.

