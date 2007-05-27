Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbXE0RIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbXE0RIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 13:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbXE0RIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 13:08:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39406 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbXE0RIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 13:08:10 -0400
Date: Sun, 27 May 2007 10:10:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-Id: <20070527101023.9c4f5952.randy.dunlap@oracle.com>
In-Reply-To: <9a1288909c10f2935af82ec5cea0c46b@pinky>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007 18:11:25 +0100 Andy Whitcroft wrote:

> 	Also if either Joel or Randy want to be on on the MAINTAINERS
> 	entry yell and we'll get it updated, wouldn't want to list
> 	anyone without permission.

Yes, please.

> 	I have the infrastructure in place to for the automated robot
> 	if and when its deemed ready.
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index a417b25..23637e8 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches

It needs to be added to Documentation/SubmitChecklist also...
(but I'm working in yard/house this holiday-not weekend).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
