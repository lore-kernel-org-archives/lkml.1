Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYKUQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYKUQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYKUQZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:25:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56548 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbYKUQZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:25:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <154e089b0811210654v45126cbene22d925a1760d9e2@mail.gmail.com>
References: <154e089b0811210654v45126cbene22d925a1760d9e2@mail.gmail.com> <154e089b0811201400w6b5d249eyc21ebb9a76133d08@mail.gmail.com> <11321.1227219571@redhat.com>
To: "Hannes Eder" <hannes@hanneseder.net>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] CRED: fix compilation warning in function 'get_cred'
Date: Fri, 21 Nov 2008 16:25:07 +0000
Message-ID: <18016.1227284707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder <hannes@hanneseder.net> wrote:

> What do you suggest, report this as a gcc bug?

You could do.  It might be worth checking to see if it's fixed with a newer
gcc first, though.

David
