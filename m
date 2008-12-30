Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYL3RHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYL3RHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYL3RG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:06:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbYL3RG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:06:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081230134248.GA30124@lst.de>
References: <20081230134248.GA30124@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: access(2) regressions in current mainline
Date: Tue, 30 Dec 2008 17:06:50 +0000
Message-ID: <24505.1230656810@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Since the merge of the current git tree into the xfs tree I see a
> regression in XFSQA 088:
> ...
> Given that XFS uses bog-standard generic_permission and the creds merge
> just happened I'd look for the cause there.  The source for the xfs
> testcase is here:

Did this test ever get run on the linux-next tree prior to the merge?  If so,
what was the result?

David
