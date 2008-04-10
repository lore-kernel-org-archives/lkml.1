Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYDJMNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYDJMNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYDJMNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:13:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53397 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755198AbYDJMNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:13:46 -0400
Date: Thu, 10 Apr 2008 07:13:43 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, bert.wesarg@googlemail.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpumask: use new cpus_scnprintf function v3
Message-Id: <20080410071343.ac957d36.pj@sgi.com>
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

Mike - could you actually list the new *list files added
by this patch?  I suspect that you can start with the
private email I sent you analyzing v2 of this patch to
obtain such a list.  If we're going to add some new /proc
and /sys files, we should list them, explicitly, by name,
and not just wave our hands with a "where appropriate."

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
