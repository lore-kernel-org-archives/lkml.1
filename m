Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbYD3RmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbYD3RmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbYD3RmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:42:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45522 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505AbYD3RmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:42:10 -0400
Subject: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 30 Apr 2008 18:42:02 +0100
Message-Id: <1209577322.25560.402.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton has been saying recently that we need an 'embedded
maintainer', to take responsibility for 'embedded issues' in the core
kernel, as well as trying to improve our relationship with those using
the Linux kernel for 'embedded' devices -- who have a reputation of
not working with us very closely; to their detriment as well as our
own.

Various people, including myself, have been doing that kind of thing
on and off over the years anyway, but Andrew is probably right that
it's worth having someone listed in the MAINTAINERS file who actually
considers it their responsibility, and as a point of contact for
people seeking advice, review, etc.

I've volunteered to take a more active rôle in this, and Wind River
has agreed to assign Paul Gortmaker to it, too.  The following patch
adds both of us to the MAINTAINERS file.

We have also set up a mailing list, linux-embedded@vger.kernel.org,
where development related to embedded stuff can happen in a slightly
less noisy environment than the main linux-kernel list. We'd like to
encourage anyone working on Linux in embedded devices to join the list.

-- 
dwmw2

