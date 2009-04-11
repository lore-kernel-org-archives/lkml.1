Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbZDKUo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbZDKUo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZDKUoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:44:20 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1080 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbZDKUoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:44:19 -0400
Subject: Re: [PATCH, RFC 3/3] tracing: Add documentation for the power
 tracer
From: Joe Perches <joe@perches.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <1239479479-2603-4-git-send-email-tytso@mit.edu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu>
	 <1239479479-2603-2-git-send-email-tytso@mit.edu>
	 <1239479479-2603-3-git-send-email-tytso@mit.edu>
	 <1239479479-2603-4-git-send-email-tytso@mit.edu>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 13:44:10 -0700
Message-Id: <1239482650.24879.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-11 at 15:51 -0400, Theodore Ts'o wrote:
> diff --git a/Documentation/power.txt b/Documentation/power.txt
> new file mode 100644
> index 0000000..16f95c9
> --- /dev/null
> +++ b/Documentation/power.txt

Documentation/trace/power.txt?
Documentation/power/trace.txt?

> @@ -0,0 +1,19 @@
> +There is a helper script found in scrips/tracing/power.pl in the kernel

scripts/tracing/power.pl


