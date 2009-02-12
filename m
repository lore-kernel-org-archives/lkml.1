Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbZBLMEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbZBLMEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbZBLMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:04:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbZBLMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:04:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090212202118.0A58.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090212202118.0A58.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <27421.1234436992@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Date: Thu, 12 Feb 2009 12:04:06 +0000
Message-ID: <27547.1234440246@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> but perhaps I am merely lucky guy.

Or perhaps Serge's patch fixes it - as I said I don't have it applied - though
I don't see exactly why it should fix this problem...

David
