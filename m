Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZGBIo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZGBIo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZGBIot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:44:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZGBIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:44:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1246472802-15824-1-git-send-email-vapier@gentoo.org>
References: <1246472802-15824-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, uclinux-dev@uclinux.org
Subject: Re: [PATCH] FLAT: use IS_ERR_VALUE() helper macro
Date: Thu, 02 Jul 2009 09:43:16 +0100
Message-ID: <20587.1246524196@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> There is a common macro now for testing mixed pointer/errno values, so use
> that rather than handling the casts ourself.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David Howells <dhowells@redhat.com>
