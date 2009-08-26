Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZHZOPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZHZOPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbZHZOO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:14:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275AbZHZOO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:14:59 -0400
Date: Wed, 26 Aug 2009 16:18:05 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Bug #14059] DomU crashes during xenfb initialization
Message-ID: <20090826161805.2697d932@leela>
In-Reply-To: <Cg6cQYLdUxG.A.XNB.5zGlKB@chimera>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	<Cg6cQYLdUxG.A.XNB.5zGlKB@chimera>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Tue, 25 Aug 2009 23:05:07 +0200 (CEST) Rafael J. Wysocki napsal:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14059
> Subject	: DomU crashes during xenfb initialization
> Submitter	: Michal Schmidt <mschmidt@redhat.com>
> Date		: 2009-08-21 10:40 (5 days old)
> References	:
> http://marc.info/?l=linux-kernel&m=125085108431360&w=4
> Handled-By	: Michal Schmidt <mschmidt@redhat.com>
> Patch		: http://patchwork.kernel.org/patch/43107/

The patch is not in mainline yet, it's only in Jeremy's git tree.
Michal
