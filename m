Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbZGGQw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbZGGQw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZGGQwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:52:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49448 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbZGGQwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:52:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A534DD0.7090606@novell.com>
References: <4A534DD0.7090606@novell.com> <20090629191653.14240.44995.stgit@dev.haskins.net> <15258.1246972893@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mst@redhat.com,
       swhiteho@redhat.com
Subject: Re: [PATCH v4] slow-work: add (module*)work->ops->owner to fix races with module clients
Date: Tue, 07 Jul 2009 17:52:16 +0100
Message-ID: <17488.1246985536@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins <ghaskins@novell.com> wrote:

> I agree, and think that looks good.  If you want to just fold that into the
> patch or something, feel free.

I've done so and pushed it Linuswards.

David
