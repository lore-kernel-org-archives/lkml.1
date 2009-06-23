Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbZFWOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbZFWOiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZFWOh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:37:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:35556 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbZFWOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:37:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 07:31:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Gregory Haskins <ghaskins@novell.com>, mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <200906231255.17015.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0906230730550.16382@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <200906231255.17015.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Rusty Russell wrote:

> The first 'struct eventfd_ctx;' line is not required.

Will repost dropping that.


- Davide


