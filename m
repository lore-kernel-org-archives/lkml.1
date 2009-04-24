Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZDXSsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZDXSsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZDXSs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:48:26 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:12236 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZDXSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:48:26 -0400
Date: Fri, 24 Apr 2009 14:47:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: =?ISO-8859-15?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc3][Regression] Compilation failure
In-reply-to: <20090424091412.GA15074@ime.usp.br>
Message-id: <alpine.LFD.2.00.0904241445430.10096@localhost.localdomain>
References: <20090424091412.GA15074@ime.usp.br>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm trying to compile a new kernel for a x86_64 computer using Debian's
> sid userland and I'm getting the following error:

> (.text+0x87d2e): undefined reference to `acpi_video_register'

try this:

http://patchwork.kernel.org/patch/19821/

thanks,
Len Brown, Intel Open Source Technology Center

