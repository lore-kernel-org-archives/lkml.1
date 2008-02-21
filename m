Return-Path: <linux-kernel-owner+w=401wt.eu-S934051AbYBUVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbYBUVR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934789AbYBUVQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:16:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934758AbYBUVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:16:32 -0500
Date: Thu, 21 Feb 2008 13:16:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
In-Reply-To: <47BDE731.60801@goop.org>
Message-ID: <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org>
References: <47BDE731.60801@goop.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Jeremy Fitzhardinge wrote:
>
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> From: Ian Campbell <ijc@hellion.org.uk>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

This is just wrong. The From: goes at the *top*, and if it's not there, 
my scripts won't pick it up as the author. 

		Linus
