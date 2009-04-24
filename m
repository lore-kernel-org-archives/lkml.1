Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbZDXGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbZDXGU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbZDXGTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:19:08 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:53496 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514AbZDXGTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:19:04 -0400
Date: Fri, 24 Apr 2009 02:18:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       stable@kernel.org, cpufreq@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       rjw@sisk.pl, Ben Slusky <sluskyb@paranoiacs.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq fix timer teardown in conservative governor
 (2.6.30-rc2)
In-reply-to: <20090424043546.GB8091@Krystal>
Message-id: <alpine.LFD.2.00.0904240217390.15843@localhost.localdomain>
References: <20090423140002.GA12852@Krystal>
 <20090423164638.3b5769c6.akpm@linux-foundation.org>
 <20090424043546.GB8091@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somebody please remind me why we are spending effort to 
maintain the conservative governor instead of deleting it.

thanks,
Len Brown, Intel Open Source Technology Center

