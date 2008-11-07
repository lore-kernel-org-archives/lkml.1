Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKGPgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKGPgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYKGPgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:36:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34985 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYKGPgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:36:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1225910127.5991.224.camel@brick>
References: <1225910127.5991.224.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] frv: use the new byteorder headers
Date: Fri, 07 Nov 2008 15:36:03 +0000
Message-ID: <1815.1226072163@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/asm-frv/byteorder.h |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)

Acked-by: David Howells <dhowells@redhat.com>
