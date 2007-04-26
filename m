Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbXDZRFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbXDZRFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXDZREG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:04:06 -0400
Received: from smtp23.orange.fr ([193.252.22.30]:11205 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbXDZRD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:03:56 -0400
X-ME-UUID: 20070426170354411.6482B1C0008F@mwinf2337.orange.fr
Subject: Re: Back to the future.
From: Xavier Bestel <xavier.bestel@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 19:03:46 +0200
Message-Id: <1177607026.30284.197.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 09:56 -0700, Linus Torvalds wrote:
> Once you have that snapshot image in user space you can do anything you 
> want. And again: you'd hav a fully working system: not any degradation 
> *at*all*. If you're in X, then X will continue running etc even after the 
> snapshotting

Won't there be problems if e.g. X tries to write something to its
logfile after snapshot ?

	Xav


