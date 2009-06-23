Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbZFWRLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbZFWRLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFWRLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:11:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48416 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZFWRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:11:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 10:04:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com,
       kvm@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups
In-Reply-To: <4A410A02.5060008@oracle.com>
Message-ID: <alpine.DEB.1.10.0906231004150.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <4A410A02.5060008@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Randy Dunlap wrote:

> kernel-doc syntax requires the function name + short description on one line,
> followed by parameters.  Any longer function description then comes after
> the parameters.
> 
> See Documentation/kernel-doc-nano-HOWTO.txt for more info,
> or ask me.

Will fix, thx!


- Davide


