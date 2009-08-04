Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbZHDGHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbZHDGHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 02:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbZHDGHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 02:07:11 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:61558 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZHDGHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 02:07:11 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Paul Mundt <lethal@linux-sh.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gelixner <tglx@linuxtronix.de>
Subject: [PATCH 0/2] Resend of ftrace recordmcount.pl fixes
Date: Tue,  4 Aug 2009 07:06:39 +0100
Message-Id: <cover.1249365713.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm resending these two patches as they seem to be stalled.

Matt Fleming (2):
  ftrace: Fix the conditional that updates $ref_func
  ftrace: Only update $offset when we update $ref_func

 scripts/recordmcount.pl |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

