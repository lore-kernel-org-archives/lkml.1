Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZEYAE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZEYAE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZEYAES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:04:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38480 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbZEYAES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:04:18 -0400
Date: Mon, 25 May 2009 01:59:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/X] ptrace: ptracee child data cleanup
Message-ID: <20090524235950.GA2198@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for early review. Ignore the tracehook-unfriendly arches for now.

This series is not complete, but other moves are trivial.

Oleg.

