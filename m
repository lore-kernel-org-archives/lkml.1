Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbXD2ORI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbXD2ORI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbXD2ORH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:17:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:37074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbXD2ORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:17:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [PATCH] [37/48] i386: ignore vgacon if hardware not present
Date: Sun, 29 Apr 2007 16:16:58 +0200
User-Agent: KMail/1.9.6
Cc: Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <200704291252.514680000@suse.de> <200704291524.54080.ak@suse.de> <1177855838.17715.18.camel@daplas>
In-Reply-To: <1177855838.17715.18.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291616.58361.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007 16:10:38 Antonino A. Daplas wrote:
> On Sun, 2007-04-29 at 15:24 +0200, Andi Kleen wrote:
> > > The subject does not reflect the content of the patch :-). And I believe
> > > ignore-vgacon-if-hardware-not-present is already in mainline.
> > 
> > Patch dropped thanks
> 
> Note that this is the patch which have the above title. So I don't know
> if you have to drop the patch or just change the title to an appropriate
> one.

I dropped the patch completely because you said it was already in mainline
or queued elsewhere. Was that wrong?

-Andi

