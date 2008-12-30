Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYL3RUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYL3RUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYL3RUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:20:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYL3RUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:20:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081230170941.GA5083@lst.de>
References: <20081230170941.GA5083@lst.de> <20081230134248.GA30124@lst.de> <24505.1230656810@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: access(2) regressions in current mainline
Date: Tue, 30 Dec 2008 17:20:26 +0000
Message-ID: <32709.1230657626@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Dec 30, 2008 at 05:06:50PM +0000, David Howells wrote:
> > Did this test ever get run on the linux-next tree prior to the merge?  If
> > so, what was the result?
> 
> I have no idea if people ever ran it, and if they did they will to
> respond for themselves..

Is it possible for me to grab the XFS test GIT tree for myself?  And can it be
run on a non-XFS filesystem?

David
