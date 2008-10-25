Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYJYX4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYJYX4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYJYX4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:56:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:33184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYJYX4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:56:43 -0400
Date: Sat, 25 Oct 2008 16:56:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] kbuild: drop cpuinit/cpuexit checks in modpost
Message-ID: <20081025165654.524247e5@infradead.org>
In-Reply-To: <20081024213710.GA18798@uranus.ravnborg.org>
References: <20081024142056.6a2d082a@infradead.org>
	<20081024213710.GA18798@uranus.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 23:37:10 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> Can you add this to the queue too.

applied and git-pushed

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
