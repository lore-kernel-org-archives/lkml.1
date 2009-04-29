Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbZD2RrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbZD2RrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZD2RrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:47:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZD2RrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:47:07 -0400
Date: Wed, 29 Apr 2009 13:45:19 -0400
Message-Id: <200904291745.n3THjJSe019520@ns3.rdu.redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org,
       fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       randy.dunlap@oracle.com, wcohen@redhat.com
From: Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/3] add tracepoint docbook
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add a new tracepoint docbook. Since tracepoints can
be defined by various macros and in various files, I think it important
to clearly document the available tracepoints, as Andrew has pointed out.
This helps us see what we have and what we don't have. If this patch is 
accepted, I hope that others will add docbook style comments, so we can 
have a complete accounting of the kernel's tracepoints.

The docbook from these patch series can be viewed at:
http://people.redhat.com/~jbaron/tracepoints/

thanks,

-Jason
