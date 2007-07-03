Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbXGCSCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbXGCSCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXGCSB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:01:58 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:61835 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665AbXGCSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:01:57 -0400
Date: Tue, 3 Jul 2007 14:01:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] Linux Kernel Markers
Message-ID: <20070703180155.GA3057@Krystal>
References: <20070703170843.204442953@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070703170843.204442953@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:01:10 up 2 days, 12:44,  3 users,  load average: 0.70, 0.31, 0.27
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please note that this release will apply on 2.6.22-rc6-mm1 and depends
on the immediate values patch.

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> This updated version of the Linux Kernel Markers mostly adds a unique 16 bits
> per marker ID and a per-probe marker group.
> 
> Christoph, I think the only concern that I do not plan to address immediately is
> to provide a complet in-kernel user of the markers (blktrace patch does not
> actually use the markers full potential). I have external patches that provides
> that, but I don't want to send too much patches at once. Between providing a
> complete marker/tracer stack and sending small incremental patches, I think the
> latter is the choice the better suited. This is however an uneasy problem, which
> looks very much like the chicken and egg problem. :)
> 
> If you have concerns with what I recently added to the markers, or if you still
> strongly feel that I must also send the following patches right away, please let
> me know.
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
