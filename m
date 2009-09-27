Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZI0LYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZI0LYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZI0LYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:24:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:45491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbZI0LYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:24:07 -0400
Date: Sun, 27 Sep 2009 13:24:30 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Message-ID: <20090927132430.28c12311@infradead.org>
In-Reply-To: <4ABF4999.9080206@upmc.fr>
References: <4ABF4999.9080206@upmc.fr>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009 13:16:41 +0200
Bernard Pidoux <bernard.pidoux@upmc.fr> wrote:

> The problem is that when I compile an application that never 
> caused any problem before I get an error due to incorrect reference
> to <asm/bitsperlong>

is this a userspace application? or some kernel module?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
