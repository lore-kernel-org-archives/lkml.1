Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZGCKtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZGCKtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZGCKtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:49:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59830 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbZGCKtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:49:43 -0400
Date: Fri, 3 Jul 2009 12:46:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] selinux_bprm_committed_creds: use __wake_up_parent()
Message-ID: <20090703104616.GA7036@redhat.com>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <11314.1246585948@turing-police.cc.vt.edu> <20090702192047.10b81ada.akpm@linux-foundation.org> <20090703081821.GA4051@redhat.com> <20090703092311.GA3712@redhat.com> <4098.1246615973@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4098.1246615973@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Valdis.Kletnieks@vt.edu wrote:
>
> Feel free to stick a
>
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Yes, thanks a lot Valdis!

Oleg.

