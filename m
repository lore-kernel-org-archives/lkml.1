Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbXEaJ2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbXEaJ2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbXEaJ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:27:43 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37196
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945AbXEaJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:27:42 -0400
From: Rob Landley <rob@landley.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] Group multiport serial card documentation under Documentation/serial
Date: Thu, 31 May 2007 03:07:14 -0400
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
References: <200705222225.39949.rob@landley.net> <200705230025.45007.rob@landley.net> <Pine.LNX.4.64.0705230922580.19474@anakin>
In-Reply-To: <Pine.LNX.4.64.0705230922580.19474@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310307.15514.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>

--

  Equivalent to:

  git-mv sx.txt stallion.txt specialix.txt rocket.txt riscom8.txt \
    computone.txt hayes-esp.txt moxa-smartio serial

diff --git a/Documentation/computone.txt b/Documentation/serial/computone.txt
similarity index 100%
rename from Documentation/computone.txt
rename to Documentation/serial/computone.txt
diff --git a/Documentation/hayes-esp.txt b/Documentation/serial/hayes-esp.txt
similarity index 100%
rename from Documentation/hayes-esp.txt
rename to Documentation/serial/hayes-esp.txt
diff --git a/Documentation/moxa-smartio b/Documentation/serial/moxa-smartio
similarity index 100%
rename from Documentation/moxa-smartio
rename to Documentation/serial/moxa-smartio
diff --git a/Documentation/riscom8.txt b/Documentation/serial/riscom8.txt
similarity index 100%
rename from Documentation/riscom8.txt
rename to Documentation/serial/riscom8.txt
diff --git a/Documentation/rocket.txt b/Documentation/serial/rocket.txt
similarity index 100%
rename from Documentation/rocket.txt
rename to Documentation/serial/rocket.txt
diff --git a/Documentation/specialix.txt b/Documentation/serial/specialix.txt
similarity index 100%
rename from Documentation/specialix.txt
rename to Documentation/serial/specialix.txt
diff --git a/Documentation/stallion.txt b/Documentation/serial/stallion.txt
similarity index 100%
rename from Documentation/stallion.txt
rename to Documentation/serial/stallion.txt
diff --git a/Documentation/sx.txt b/Documentation/serial/sx.txt
similarity index 100%
rename from Documentation/sx.txt
rename to Documentation/serial/sx.txt
