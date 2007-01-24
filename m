Return-Path: <linux-kernel-owner+w=401wt.eu-S1751562AbXAXQMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbXAXQMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXAXQMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:12:34 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:62424 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbXAXQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:12:33 -0500
X-AuditID: d80ac287-9e09dbb0000026f2-86-45b78755cf01 
Date: Wed, 24 Jan 2007 16:12:46 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Chris Rankin <rankincj@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.18-stable release plans?
In-Reply-To: <964414.64865.qm@web52908.mail.yahoo.com>
Message-ID: <Pine.LNX.4.64.0701241607160.17843@blonde.wat.veritas.com>
References: <964414.64865.qm@web52908.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Jan 2007 16:12:33.0047 (UTC) FILETIME=[74509A70:01C73FD2]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, Chris Rankin wrote:
> 
> I suppose what I'm *really* asking is what the basis is for assuming that this *isn't* a kernel
> bug and can therefore be safely ignored, seeing as the oops is real, the hardware is fine and the
> kernel is untainted? That seems to cover the bases from where I'm sitting.

All I'm claiming is that it's no more a reason to avoid 2.6.19*
than to avoid any other release (the kernels before 2.6.7 happened
to have no such check, but that doesn't imply they were any safer).

It may indeed be due to a kernel bug, but I can't tell you where: sorry.

Hugh
