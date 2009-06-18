Return-Path: <linux-kernel-owner+w=401wt.eu-S1764642AbZFRO2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764642AbZFRO2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762916AbZFRO1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:27:04 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:55954 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbZFRO0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:26:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEABnlOUpMQWZ4/2dsb2JhbACBUNAWhAgF
Date: Thu, 18 Jun 2009 10:26:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: davem@redhat.com, Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: bob_jenkins@burtleburtle.net, linux-kernel@vger.kernel.org
Subject: jhash.h license
Message-ID: <20090618142649.GA15262@Krystal>
References: <4A3A4A57.8070606@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4A3A4A57.8070606@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:21:18 up 110 days, 10:47,  4 users,  load average: 1.72, 1.67,
	1.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

It looks like we would need the jhash.h implementation from the Linux
kernel for the LGPL LTTng tracing library. It seems this code is derived
from Bob Jenkins' public domain code.

Is your intent to release it as public domain too ?

Otherwise we'll have to re-do some adaptations from his sources at
http://burtleburtle.net/bob/hash/ .

Thanks,

Mathieu

* Pierre-Marc Fournier (pierre-marc.fournier@polymtl.ca) wrote:
> Hi Dave,
> 
> I am currently working on a userspace port of the LTTng tracer. Would
> allow me to distribute jhash.h from the Linux kernel as LGPL v2.1?
> 
> I am not sure whether your intent was to distribute the file in the
> public domain, keeping Bob Jenkins' licence, or as GPL.
> 
> Thanks.
> 
> pmf
> 


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
