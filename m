Return-Path: <linux-kernel-owner+w=401wt.eu-S936186AbYD1Uzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186AbYD1Uzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934704AbYD1UzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:55:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934687AbYD1UzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:55:24 -0400
Message-ID: <48163989.2000405@zytor.com>
Date: Mon, 28 Apr 2008 13:54:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] dup2 w/flags
References: <200804280320.m3S3KSFu028466@devserv.devel.redhat.com> <517f3f820804280243q4a4bb9dbv27ce4be90fdd5954@mail.gmail.com>
In-Reply-To: <517f3f820804280243q4a4bb9dbv27ce4be90fdd5954@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> 
> Ulrich,
> 
> To repeat my earlier request, and as requested in Documentation/HOWTO,
> could you please CC me on API changes.  This alerts me to what may
> eventually need documenting in man-pages.
> 

I think we may need a mailing list for this; you're not the only person 
who would be affected by ABI-visible changes.

	-hpa
