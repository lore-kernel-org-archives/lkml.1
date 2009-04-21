Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZDUJOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZDUJOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZDUJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:14:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZDUJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:14:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: A couple more small fixes
Date: Tue, 21 Apr 2009 09:09:27 +0100
Message-Id: <1240301369-12585-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both of the following patches are pretty small. The patch to clear
the dirty bit at the end of the glock flush is the more important
one for now,

Steve.


