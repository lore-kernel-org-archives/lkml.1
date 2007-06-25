Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXFYXYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXFYXYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXFYXYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:24:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbXFYXYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:24:14 -0400
Message-ID: <46804E8B.60401@redhat.com>
Date: Mon, 25 Jun 2007 19:23:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       =?ISO-8859-1?Q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706242254.59695.rjw@sisk.pl> <467FEF6E.9050908@redhat.com> <200706260120.13940.rjw@sisk.pl>
In-Reply-To: <200706260120.13940.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 07:20 PM, Rafael J. Wysocki wrote:
> Still, I know that, for example, the Fedora 2.6.21-1.3193.fc8 kernel is in fact
> 2.6.22-rc3 (see http://bugzilla.kernel.org/show_bug.cgi?id=7988#c11).  Is there
> a straightforward way to 'decode' such names? ;-)
> 

http://cvs.fedora.redhat.com/viewcvs/rpms/kernel/devel/kernel-2.6.spec?annotate=HEAD&root=extras

Then scroll down to the changelog. :)

I started putting the CVS version in FC6 changelogs but that doesn't
have this kind of churn.
