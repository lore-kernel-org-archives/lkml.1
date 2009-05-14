Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbZEOUrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbZEOUrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZEOUrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:47:23 -0400
Received: from dsl-fixed-62-69-39-101.surfdsl.murphx.net ([62.69.39.101]:38201
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751349AbZEOUrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:47:22 -0400
X-Greylist: delayed 2528 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2009 16:47:22 EDT
Date: Thu, 14 May 2009 21:29:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: devzero@web.de
Cc: akataria@vmware.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090514212901.2a94c3ab@lxorguk.ukuu.org.uk>
In-Reply-To: <715998165@web.de>
References: <715998165@web.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was done as a back compatible option and with tickless the future it
wasn't really planned for upstreaming. No reason I can see it shouldn't
be however.

Alan
