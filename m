Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbZEML6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbZEML6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZEML6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:58:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49847 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZEML6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:58:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0905101959070.2913@ubuntu-desktop>
References: <alpine.DEB.2.00.0905101959070.2913@ubuntu-desktop> <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] use round_jiffies() for slow work thread pool's 5 second cull timer
Date: Wed, 13 May 2009 12:58:34 +0100
Message-ID: <5083.1242215914@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Peterson <cpeterso@cpeterso.com> wrote:

> This is a revised patch to round the slow work queue's 5 second timers to 
> whole seconds with round_jiffies().

Why?  Your patch description doesn't say.

David
