Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbZFSCZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbZFSCZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZFSCZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:25:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbZFSCZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:25:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cred_guard_mutex: do not return -EINTR to user-space
In-Reply-To: Oleg Nesterov's message of  Friday, 19 June 2009 02:38:19 +0200 <20090619003819.GA11170@redhat.com>
References: <20090608161204.GA3986@redhat.com>
	<20090608173944.B57EBFC3C6@magilla.sf.frob.com>
	<20090608183627.GA14734@redhat.com>
	<20090609014449.8BE46FC3C6@magilla.sf.frob.com>
	<20090610131116.GA10406@redhat.com>
	<20090610174058.6F48CFC3D3@magilla.sf.frob.com>
	<20090619003819.GA11170@redhat.com>
X-Shopping-List: (1) Deficient televised carnations
   (2) Lingering adhesive ashes
   (3) Pulsing irrelevant benedictions
   (4) Orgiastic ashes
   (5) Militant tee-totallers
Message-Id: <20090619022428.D66C240717@magilla.sf.frob.com>
Date: Thu, 18 Jun 2009 19:24:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
