Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYDJONm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYDJONm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYDJONe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:13:34 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753675AbYDJONd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:13:33 -0400
Date: Thu, 10 Apr 2008 09:13:31 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, bert.wesarg@googlemail.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpumask: add show cpu map functions v2
Message-Id: <20080410091331.8203d266.pj@sgi.com>
In-Reply-To: <20080408184302.113424000@polaris-admin.engr.sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<20080408184302.113424000@polaris-admin.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
>   * Add cpu_sysdev_class functions to display the following maps
>     with cpulist_scnprintf().

Nice - thanks.

Reviewed-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
