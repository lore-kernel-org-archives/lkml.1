Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZGAPM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZGAPM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZGAPMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:12:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43321 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbZGAPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:12:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 1 Jul 2009 08:11:43 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the kvm tree with Linus' tree
In-Reply-To: <4A4B56FE.8060407@novell.com>
Message-ID: <alpine.DEB.1.10.0907010811020.10303@makko.or.mcafeemobile.com>
References: <20090701145711.1c9c8935.sfr@canb.auug.org.au> <alpine.DEB.1.10.0907010007020.8745@makko.or.mcafeemobile.com> <4A4B1106.8000506@redhat.com> <4A4B56FE.8060407@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Gregory Haskins wrote:

> Just to be clear: the final form will need to be wake_up_poll(), not
> wake_up_locked_poll.

Yep, sorry I missed that one.


- Davide


