Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYDJAcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYDJAcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYDJAcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:32:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55018 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752350AbYDJAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:32:15 -0400
Date: Wed, 9 Apr 2008 19:32:12 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, bert.wesarg@googlemail.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpumask: use new cpus_scnprintf function v3
Message-Id: <20080409193212.c4b32675.pj@sgi.com>
In-Reply-To: <20080408184301.975491000@polaris-admin.engr.sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184301.975491000@polaris-admin.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
> added new cpulist_scnprintf() interfaces where appropriate.

Nice - thanks.

When I get off vacation tomorrow, I will try to review this
more closely.  However I definitely approve of the idea of
the separate, list formatted, /sys and /proc files.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
