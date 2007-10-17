Return-Path: <linux-kernel-owner+w=401wt.eu-S936478AbXJQClw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936478AbXJQClw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936234AbXJQClg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:41:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936073AbXJQCle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:41:34 -0400
Date: Tue, 16 Oct 2007 22:41:26 -0400
From: Rik van Riel <riel@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Distinguishing releases from pre-rc snapshots
Message-ID: <20071016224126.3679aea6@bree.surriel.com>
In-Reply-To: <1192587763.3672.24.camel@dv>
References: <1192587763.3672.24.camel@dv>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 22:22:43 -0400
Pavel Roskin <proski@gnu.org> wrote:

> I'm trying to keep some external drivers up to date with the kernel,
> and the first two weeks after the release is the worst time for me.

Consider this an incentive to submit your code for inclusion
in the upstream kernel.  Having all the common drivers integrated
in the mainline kernel makes it much easier for users to use all
their hardware, external drivers are not just a pain for the developers.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
