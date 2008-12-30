Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbYL3Ry0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbYL3Ry0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYL3RyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:54:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53271 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYL3RyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:54:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081230172901.GA5610@lst.de>
References: <20081230172901.GA5610@lst.de> <20081230170941.GA5083@lst.de> <20081230134248.GA30124@lst.de> <24505.1230656810@redhat.com> <32709.1230657626@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: access(2) regressions in current mainline
Date: Tue, 30 Dec 2008 17:54:11 +0000
Message-ID: <605.1230659651@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Try to grab git://oss.sgi.com/xfs-cmds, it's in the xfstests subdir.

Hmmm...  It requires an 'fsstress', but which of the several things that go by
that name is it referring to?

David
