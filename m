Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZBEPHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZBEPHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZBEPHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:07:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42820 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZBEPHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:07:07 -0500
Date: Thu, 5 Feb 2009 10:07:05 -0500
From: Bill Nottingham <notting@redhat.com>
To: Harald Hoyer <harald@redhat.com>
Cc: linux-kernel@vger.kernel.org, power@bughost.org
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090205150705.GC6865@nostromo.devel.redhat.com>
Mail-Followup-To: Harald Hoyer <harald@redhat.com>,
	linux-kernel@vger.kernel.org, power@bughost.org
References: <497F69A4.2070007@intel.com> <20090130202219.GA1253@ucw.cz> <20090203133251.GD29046@elte.hu> <gmeu0q$n13$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gmeu0q$n13$1@ger.gmane.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Hoyer (harald@redhat.com) said: 
> Can strace can be used on init?
>
> $ man strace
> ...
>        On Linux, exciting as it would be, tracing the init process is forbidden.
> ...
>
> Any hope getting _any_ mechanism in the kernel??

The man page probably needs fixed - this works as of a few kernel releases
ago.

Bill
