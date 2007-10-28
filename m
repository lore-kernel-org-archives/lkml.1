Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbXJ1VjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbXJ1VjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXJ1VjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:39:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45358 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXJ1VjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:39:08 -0400
Date: Sun, 28 Oct 2007 14:34:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "lists@antonello.org" <lists@antonello.org>
Cc: Samuel Tardieu <sam@rfc1149.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight dimmer
Message-ID: <20071028143445.4617efd8@laptopd505.fenrus.org>
In-Reply-To: <4724FF8F.30306@antonello.org>
References: <4724B48D.6090405@antonello.org>
	<87y7dndxm3.fsf@willow.rfc1149.net>
	<4724FF8F.30306@antonello.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 22:30:55 +0100
"lists@antonello.org" <lists@antonello.org> wrote:

> Ok,
>   now checkpatch.pl only complains about a missing signed-off-by.
> Is this ok for review?


hi,

when going over your patch.. is there a reason you introduce yet
another timeout infrastructure? Is there something wrong with the
existing ones that maybe should be fixed instead?
Either way.. please put justification for such new mechanism in the
patch changelog....

Greetings,
   Arjan van de Ven

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
