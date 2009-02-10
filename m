Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBJKtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBJKtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZBJKtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:49:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50157 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZBJKtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:49:40 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
Cc: kosaki.motohiro@jp.fujitsu.com, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <25349.1234262157@redhat.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <25349.1234262157@redhat.com>
Message-Id: <20090210194900.6FE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 19:49:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > It paniced with following stack.
> > Do you have any suggestions?
> 
> Are you running with CONFIG_DEBUG_SLAB=y?

No. I try this tonight testing.
thanks.


