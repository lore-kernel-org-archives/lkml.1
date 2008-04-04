Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYDDQ31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYDDQ31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYDDQ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:29:17 -0400
Received: from [194.117.236.238] ([194.117.236.238]:60451 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYDDQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:29:16 -0400
Date: Fri, 4 Apr 2008 19:28:47 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] relay: add buffer-only functionality, allowing for
 early kernel tracing
Message-ID: <20080404192847.394d5339@linux360.ro>
In-Reply-To: <20080404090801.c988f96f.randy.dunlap@oracle.com>
References: <20080404183303.2e239a20@linux360.ro>
	<20080404090801.c988f96f.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for spotting these problems, Randy.  I'll fix them and resubmit.


Cheers,
Eduard
