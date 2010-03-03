Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0CCHEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:04:41 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:41834 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0CCHEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=S2YvvE23IeUB0BosvnSubeKV4H3s1Wiu7Bz5nMLRwM7NikH/RrnRHQIHpNQqftbsjh
         Yy+SD/1dJQiPD2IcoeqUdWs/sFsBJCavcOl3ABu/Ejt/b0WwWweeNWzEIQLbxUjNIUux
         2GgnZgyI1XDrT1tV11exxs5epgxtn+4U3gq/I=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 0/2] perf trace: a couple small fixes
Date: Wed,  3 Mar 2010 01:04:31 -0600
Message-Id: <1267599873-8193-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi (2):
  perf trace/scripting: remove extraneous header read
  perf trace: don't use pager if scripting

 tools/perf/builtin-trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

