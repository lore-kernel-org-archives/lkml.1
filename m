Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbZD2SSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbZD2SSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZD2SSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:18:12 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:57851 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436AbZD2SSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:18:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsFAMsx+ElMQW1W/2dsb2JhbACBUM8gg3UF
Date: Wed, 29 Apr 2009 14:17:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       rostedt@goodmis.org, fweisbec@gmail.com, randy.dunlap@oracle.com,
       wcohen@redhat.com
Subject: Re: [PATCH 0/3] add tracepoint docbook
Message-ID: <20090429181756.GA8793@Krystal>
References: <200904291745.n3THjJSe019520@ns3.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200904291745.n3THjJSe019520@ns3.rdu.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:14:23 up 60 days, 14:40,  1 user,  load average: 0.35, 0.44,
	0.42
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> The following patches add a new tracepoint docbook. Since tracepoints can
> be defined by various macros and in various files, I think it important
> to clearly document the available tracepoints, as Andrew has pointed out.
> This helps us see what we have and what we don't have. If this patch is 
> accepted, I hope that others will add docbook style comments, so we can 
> have a complete accounting of the kernel's tracepoints.
> 
> The docbook from these patch series can be viewed at:
> http://people.redhat.com/~jbaron/tracepoints/
> 
> thanks,
> 
> -Jason

Documenting tracepoints is clearly needed. So this patch looks good to
me.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
