Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbXD2RQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbXD2RQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXD2RQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:16:16 -0400
Received: from gw.goop.org ([64.81.55.164]:53633 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbXD2RQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:16:15 -0400
Message-ID: <4634D2E6.5000307@goop.org>
Date: Sun, 29 Apr 2007 10:16:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [37/48] i386: ignore vgacon if hardware not present
References: <200704291252.514680000@suse.de> <200704291524.54080.ak@suse.de> <1177855838.17715.18.camel@daplas> <200704291616.58361.ak@suse.de>
In-Reply-To: <200704291616.58361.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I dropped the patch completely because you said it was already in mainline
> or queued elsewhere. Was that wrong?
>   
I think both patches are actually needed.  The -mm message Antonio
quoted probably refers to the fact that the patch is in your tree, so
Andrew isn't carrying it separately.

The patch called "ignore-vgacon-if-hardware-not-present" on
firstfloor.org is what the name suggests.  It appears to be still
needed, because it still applies.

The patch you've posted here with the subject "i386: ignore vgacon if
hardware not present" is actually i386-eflags-header, but it appears to
have a bad first line, which is why it is posted with the wrong subject.

    J
