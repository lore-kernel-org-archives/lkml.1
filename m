Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZGLU0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZGLU0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZGLU0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:26:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:37813 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZGLU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=E5kAdQO6qL7pmXCMhenQ8iWgLQKc/9ceUqQhRd18RKLV/rqMGd3CGYGDYn0tX12Ti9
         DwAL3pVsiZ4L+6gPb16dTQ+lMoTYSDGbW8Zht2ptGNAi/as9l9TvXaMvBNKh4QckK3+9
         5rQ46nTHxeWIzQnRknuyYwemdXBYJqiPqU2uk=
Date: Sun, 12 Jul 2009 16:26:35 -0400
From: Celejar <celejar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: suspend to disk now broken
Message-Id: <20090712162635.0e451001.celejar@gmail.com>
In-Reply-To: <200907122219.53116.rjw@sisk.pl>
References: <20090712151947.25446ceb.celejar@gmail.com>
	<200907122219.53116.rjw@sisk.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 22:19:52 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 12 July 2009, Celejar wrote:
> > Hi,
> > 
> > A recent change to the kernel has apparently broken suspend to disk on
> > my machine.  It still works fine in 2.6.30.1, but hangs during the
> > 'devices' phase of suspension with 2.6.31-rc2.  [I originally saw the

...

> Do you use s2disk or 'echo disk > /sys/power/state'?

First 'hibernate', then 's2disk', and finally 'echo ...' :)  None work.

Celejar
--
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

