Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134Ab0AEQrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0AEQrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951Ab0AEQrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:47:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab0AEQrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:47:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1261541188.3508.67.camel@localhost.localdomain>
References: <1261541188.3508.67.camel@localhost.localdomain> <1261540762.3508.61.camel@localhost.localdomain> <1261540826.3508.62.camel@localhost.localdomain> <1261540902.3508.63.camel@localhost.localdomain> <1261540988.3508.64.camel@localhost.localdomain> <1261541054.3508.65.camel@localhost.localdomain> <1261541130.3508.66.camel@localhost.localdomain> 
To: john stultz <johnstul@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 6/14] Convert frv to read/update_persistent_clock
Date: Tue, 05 Jan 2010 16:47:39 +0000
Message-ID: <26073.1262710059@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> wrote:

> This patch converts the frv architecture to use the generic
> read_persistent_clock and update_persistent_clock interfaces, reducing
> the amount of arch specific code we have to maintain, and allowing for
> further cleanups in the future.
> 
> I have not built or tested this patch, so help from arch maintainers
> would be appreciated.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
