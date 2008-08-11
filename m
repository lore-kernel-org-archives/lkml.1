Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbYHKJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbYHKJ0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYHKJ0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:26:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYHKJ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:26:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080808163452.GR14495@cs181140183.pp.htv.fi>
References: <20080808163452.GR14495@cs181140183.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [11/17] mn10300: use bcd2bin/bin2bcd
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 11 Aug 2008 10:26:13 +0100
Message-ID: <5284.1218446773@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adrian Bunk <bunk@kernel.org> wrote:

> This patch changes mn10300 to use the new bcd2bin/bin2bcd functions 
> instead of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: David Howells <dhowells@redhat.com>
