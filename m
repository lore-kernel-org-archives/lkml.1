Return-Path: <linux-kernel-owner+w=401wt.eu-S933166AbZGPTtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbZGPTtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933116AbZGPTtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:49:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54207 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbZGPTty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:49:54 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 0/3] tracing: minor bugs
Date: Thu, 16 Jul 2009 21:44:25 +0200
Message-Id: <1247773468-11594-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

1/3 - removing not used variables
2/3 - removing struct module* parameter from ftrace_init_module code path
3/3 - removing .globl in the scripts/recordmcount.pl doc

based on Linus tree commit 35b5c55fee08e6e4001ba98060a2d0b82f70b5f4 

wbr,
jirka
