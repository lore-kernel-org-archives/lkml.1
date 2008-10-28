Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYJ1O3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYJ1O3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYJ1O3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:29:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33720 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYJ1O3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:29:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1225200833.8039.26.camel@plop>
References: <1225200833.8039.26.camel@plop> <20080817194532.GB15440@nospam.com> <524f69650808171818r781115c5w170cc58b91866b4c@mail.gmail.com>
To: Pascal Terjan <pterjan@mandriva.com>
Cc: dhowells@redhat.com, Rutger Nijlunsing <rutger.nijlunsing@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Steve French <smfrench@gmail.com>
Subject: Re: OOPS in request_key.c bisected (and then refound)
Date: Tue, 28 Oct 2008 14:28:48 +0000
Message-ID: <3450.1225204128@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan <pterjan@mandriva.com> wrote:

> This patch was confirmed by a user here to fix the oops (happened while
> using mount.cifs with kerberos).
> Is there a reason not to merge it (and into stable too) ?

I thought it was upstream, but I think I must've been looking at the wrong
GIT tree.  I'll push it now.

David
