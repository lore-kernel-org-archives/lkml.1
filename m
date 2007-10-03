Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbXJCPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbXJCPbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbXJCPbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:31:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1304 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXJCPbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=h97eJ2vO6pEMdjJ5yb3MJoZa+oQkDa6IUdSlawXvTRwg0P/HByBhFS/rhY5mASIfk5aoKBI/Wq+q6JA68jgGEMuqsnD8gkyOjQfA0MVIkZPvkNQrUww4K0XFkarDbzEjoMwNPsyQiXKqdtSmWkhsz6pRnnCZE6/Hon3e+EfLBZY=
Date: Wed, 3 Oct 2007 17:28:07 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-Id: <20071003172807.6996fa3e.diegocg@gmail.com>
In-Reply-To: <alpine.LFD.0.999.0710021630560.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	<20071003010730.2fb7ec5c.diegocg@gmail.com>
	<alpine.LFD.0.999.0710021630560.3579@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Oct 2007 16:32:00 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> escribió:

> Heh. The "remove sk98lin driver" bullet is sadly wrong. We had to 
> reinstate it because it supported some cards that the skge driver doesn't 
> handle.

Thanks, fixed
