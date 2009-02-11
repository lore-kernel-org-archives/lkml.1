Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZBKVO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZBKVO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZBKVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:14:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbZBKVOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:14:50 -0500
Date: Wed, 11 Feb 2009 22:12:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/4] forget_original_parent: misc
Message-ID: <20090211211212.GA16839@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop

	"[PATCH 4/4] forget_original_parent: cleanup ptrace pathes"
	forget_original_parent-cleanup-ptrace-pathes.patch

this series tries to address Roland's comments/suggestions.

5/4 is off-topic but trivial.

Oleg.

