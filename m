Return-Path: <linux-kernel-owner+w=401wt.eu-S1764957AbYCFLFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764957AbYCFLFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbYCFLAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:00:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbYCFLAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:00:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] handle_stop_signal: unify partial/full stop handling
In-Reply-To: Oleg Nesterov's message of  Tuesday, 4 March 2008 21:57:46 +0300 <20080304185746.GA8485@tv-sign.ru>
References: <20080304185746.GA8485@tv-sign.ru>
Emacs: if SIGINT doesn't work, try a tranquilizer.
Message-Id: <20080306105936.0DE352700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 02:59:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three all look fine to me.


Thanks,
Roland
