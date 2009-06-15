Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbZFOMUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbZFOMUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZFOMTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:19:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39959 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZFOMTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:19:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090613182721.GA24072@jukie.net>
References: <20090613182721.GA24072@jukie.net>
To: Bart Trojanowski <bart@jukie.net>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [v2.6.30 nfs+fscache] kswapd1: blocked for more than 120 seconds
Date: Mon, 15 Jun 2009 13:19:44 +0100
Message-ID: <25357.1245068384@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski <bart@jukie.net> wrote:

>   - my cachefilesd uses xfs on MD raid0 volume over two SATA disks

Is it possible for you try it with ext3 instead of XFS?  I'd be interested to
know if this is something XFS specific.

David
