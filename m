Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXD2Rqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXD2Rqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXD2Rqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:46:35 -0400
Received: from mail.suse.de ([195.135.220.2]:48351 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051AbXD2Rqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:46:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] [37/48] i386: ignore vgacon if hardware not present
Date: Sun, 29 Apr 2007 19:39:48 +0200
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200704291252.514680000@suse.de> <200704291616.58361.ak@suse.de> <4634D2E6.5000307@goop.org>
In-Reply-To: <4634D2E6.5000307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291939.48551.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The patch you've posted here with the subject "i386: ignore vgacon if
> hardware not present" is actually i386-eflags-header, but it appears to
> have a bad first line, which is why it is posted with the wrong subject.

Ok should be fixed now and i readded the patch.

-Andi
