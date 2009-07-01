Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZGAHkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZGAHkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZGAHkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:40:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbZGAHkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:40:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 1/3] elf: fix one check-after-use
In-Reply-To: Amerigo Wang's message of  Wednesday, 1 July 2009 01:06:26 -0400 <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
Emacs: impress your (remaining) friends and neighbors.
Message-Id: <20090701073928.4F93A21D57@magilla.sf.frob.com>
Date: Wed,  1 Jul 2009 00:39:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Check before use it.

Oops!  I don't know how that snuck in there.  Good catch.

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland

