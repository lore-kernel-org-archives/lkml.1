Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZKGWI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZKGWI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZKGWIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:08:23 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60389 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZKGWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=GDhCoRBMAQFRUzlif6SR6GDf1/psqf1gsLSzOttqFg4exIJA1bplIAW0t3PLf+AI5e
         qJQvC8Ck1CUBc3rHCmuaOlNPvJQv2pNKzWQCNjGVqBr8iwajEISldDN2E3ws4QKGKGMc
         +oxvM9zGNG8PEr8RfdUDmvtNjT9fFyy3Bop4Q=
MIME-Version: 1.0
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sun, 8 Nov 2009 00:08:07 +0200
Message-ID: <12d7e64c0911071408m51ce62bdk5530fc52a1c4172@mail.gmail.com>
Subject: [PATCH] perf tools: fix syntax in documentation
To: Ingo Molnar <mingo@elte.hu>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is against current tip.


Fix trivial syntax in perf-events user-space tools documentation.
Signed-off-by: Zeev Tarantov <zeev.tarantov@gmail.com>

--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -24,11 +24,11 @@ OPTIONS
 --dsos=::
        Only consider symbols in these dsos. CSV that understands
        file://filename entries.
--n
---show-nr-samples
+-n::
+--show-nr-samples=::
        Show the number of samples for each symbol
--T
---threads
+-T::
+--threads=::
        Show per-thread event counters
 -C::
 --comms=::
