Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbYKVAge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbYKVAge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYKVAgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:36:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51111 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbYKVAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:36:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <154e089b0811211222x5340b78cx496edb25abd1147f@mail.gmail.com>
References: <154e089b0811211222x5340b78cx496edb25abd1147f@mail.gmail.com> <154e089b0811201400w6b5d249eyc21ebb9a76133d08@mail.gmail.com> <11321.1227219571@redhat.com> <154e089b0811210654v45126cbene22d925a1760d9e2@mail.gmail.com> <18016.1227284707@redhat.com>
To: "Hannes Eder" <hannes@hanneseder.net>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] CRED: fix compilation warning in function 'get_cred'
Date: Sat, 22 Nov 2008 00:36:18 +0000
Message-ID: <19569.1227314178@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder <hannes@hanneseder.net> wrote:

> The spurious warning is gone with gcc (Ubuntu 4.3.2-1ubuntu11) 4.3.2.

Then I wouldn't worry about it too much.

David
