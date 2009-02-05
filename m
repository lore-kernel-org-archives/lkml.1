Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbZBEAnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbZBEAnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZBEAnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:43:41 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:37412 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZBEAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nEpzEEL4lqew1H/QonlSAVAc6vnl9H44QBnBhWk3l+RAmXFEC3V9tHb3n6ehlJnVdN
         Va1G5Ogj5mkMGcEMh6H9DPzEiCTppSmcVJZfNunP2Fz4qvaYXnkl0I1NITZrRqhG6YHe
         O1vSpmGZVIxwAc8gB9lh4EAeXgVJH1GMpAOcY=
Date: Wed, 4 Feb 2009 19:43:30 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [Bug #12598] tg3 dead after resume
In-Reply-To: <pWZw1SZjMCH.A.QEF._uYiJB@chimera>
Message-ID: <alpine.DEB.2.00.0902041941440.6694@parag-desktop>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.QEF._uYiJB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12598
> Subject		: tg3 dead after resume
> Submitter	: Parag Warudkar <parag.lkml@gmail.com>
> Date		: 2009-01-29 0:14 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=123318968501524&w=4
> Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
> 		  Rafael J. Wysocki <rjw@sisk.pl>
> Patch		: http://marc.info/?l=linux-kernel&m=123365342301877&w=4

OK to close - haven't checked if the patch made it to Linus' tree, 
assuming yes.

Parag
