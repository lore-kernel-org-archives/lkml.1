Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZGJBbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZGJBbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZGJBat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:30:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbZGJBas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:30:48 -0400
Date: Fri, 10 Jul 2009 03:27:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm_for_maps: minor cleanups/fixes
Message-ID: <20090710012735.GA384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous discussion, on top of

	"mm_for_maps: simplify, use ptrace_may_access()"
	commit a893a84e8799270fbec5c3708d001650aab47138

in git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Oleg.

