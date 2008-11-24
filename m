Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYKXXVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYKXXVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYKXXVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:21:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39124 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbYKXXVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:21:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com>
References: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com>
To: "Hannes Eder" <hannes@hanneseder.net>
Cc: dhowells@redhat.com, "James Morris" <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] CRED: fix sparse warnings
Date: Mon, 24 Nov 2008 23:21:09 +0000
Message-ID: <5008.1227568869@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder <hannes@hanneseder.net> wrote:

>   security/security.c:228:2: warning: returning void-valued expression
>   security/security.c:233:2: warning: returning void-valued expression
>   security/security.c:616:2: warning: returning void-valued expression

What's wrong with that?

David
