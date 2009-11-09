Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZKICLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZKICLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZKICLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:11:41 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38576 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZKICLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=db7sbRrQ24j/pTQT3kFda8HvTuFH6IJNXptSPdW+LTEJ586cntwcOS64/v5+dRDEsC
         Ai2A4oi7b1Xt3HBs1bWtmr2jARUCt9Z2ksBxyXkRQ24koIPr17vb3qBamEWKCR29pkd4
         KMh8ovUQeYh9Ou8BWptCn+p+Q2uJk1Ci1TaXM=
MIME-Version: 1.0
In-Reply-To: <12d7e64c0911071408m51ce62bdk5530fc52a1c4172@mail.gmail.com>
References: <12d7e64c0911071408m51ce62bdk5530fc52a1c4172@mail.gmail.com>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Mon, 9 Nov 2009 04:11:25 +0200
Message-ID: <12d7e64c0911081811i7e5b466cu6706ff6ab3e70db4@mail.gmail.com>
Subject: [PATCH, v2] perf tools: fix syntax in documentation
To: Ingo Molnar <mingo@elte.hu>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A big "thank you" to Ingo Molnar for pointing out that gmail changes
tabs into spaces.
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
