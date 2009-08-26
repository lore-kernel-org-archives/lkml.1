Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZHZUzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZHZUzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZHZUzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:55:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36164 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZHZUzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:55:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tomas M." <tmezzadra@gmail.com>
Subject: Re: [Bug #13836] suspend script fails, related to stdout?
Date: Wed, 26 Aug 2009 22:56:30 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.es.4tGlKB@chimera> <4A951838.4090803@gmail.com>
In-Reply-To: <4A951838.4090803@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262256.30212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Tomas M. wrote:
> yes, this is still the case, the same script (netcfg from archlinux) 
> fails during boot too.

Thanks for the update.

Rafael

 
> Rafael J. Wysocki wrote:
> 
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13836
> Subject		: suspend script fails, related to stdout?
> Submitter	: Tomas M. <tmezzadra@gmail.com>
> Date		: 2009-07-17 21:24 (40 days old)
> References	: http://marc.info/?l=linux-kernel&m=124785853811667&w=4
