Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZEROAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZEROAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZEROAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:00:40 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:49542 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZEROAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:00:39 -0400
Date: Mon, 18 May 2009 16:00:35 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-ID: <20090518160035.6ea22eb7@skybase>
In-Reply-To: <Pine.LNX.4.64.0905181421300.1088@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905181421300.1088@venus.araneidae.co.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 14:23:03 +0100 (BST)
Michael Abbott <michael@araneidae.co.uk> wrote:

> Resending this patch, as it doesn't seem to have made it into the kernel 
> (and this feature really doesn't need to be left broken).

I'll queue it to the cputime branch on git390 and send Linus a please
pull. Perhaps that will get the patch upstream.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

