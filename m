Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbXEIXIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbXEIXIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXEIXI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:08:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52747 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbXEIXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:08:25 -0400
Date: Wed, 9 May 2007 16:13:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Shahbaz Khan" <shaz.linux@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: What tools to use?
Message-Id: <20070509161312.02560f00.randy.dunlap@oracle.com>
In-Reply-To: <20cbb9450705091557p53e771f6g7cb2c8b0491a3d8a@mail.gmail.com>
References: <20cbb9450705091557p53e771f6g7cb2c8b0491a3d8a@mail.gmail.com>
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

On Thu, 10 May 2007 03:57:21 +0500 Shahbaz Khan wrote:

> All the experts on this list plz let me know of any good cross
> referencing tool for source code navigation. I have tried LXR but its
> not easy to configure for a rookie like me. Anyother as good as LXR?

It's not a web browser interface, but cscope works pretty well.

http://cscope.sourceforge.net/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
