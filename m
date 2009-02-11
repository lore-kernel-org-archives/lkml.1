Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZBKMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZBKMli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZBKMl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:41:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41251 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbZBKMl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:41:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Date: Wed, 11 Feb 2009 12:41:18 +0000
Message-ID: <27780.1234356078@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> I periodically test kernel on stress workload.

Can you say more about the stress workload you're using?

And can you give us your kernel config?

David
