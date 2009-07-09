Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZGIBTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZGIBTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZGIBT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:19:28 -0400
Received: from tundra.namei.org ([65.99.196.166]:45817 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbZGIBT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:19:27 -0400
Date: Thu, 9 Jul 2009 11:19:17 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, charles.f.johnson@intel.com
Subject: Re: [PATCH] This is the security processor driver for the Intel mid
 platform
In-Reply-To: <20090709001716.3dca2032@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LRH.2.00.0907091105570.31140@tundra.namei.org>
References: <1247083262-17356-1-git-send-email-mark.a.allyn@intel.com> <20090709001716.3dca2032@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Alan Cox wrote:

> On Wed,  8 Jul 2009 13:01:02 -0700
> Mark Allyn <mark.a.allyn@intel.com> wrote:
> 
> > This is the driver for the Security Processor (SEP) for the Intel MID Platform.
> > 

> Whats a SEP ? (I know that but I work for Intel ;)). This needs a longer
> text and a description that would be useful to more people. The one in
> your intro text is probably pretty close.

Also, please cc the linux-security-module list with security related code, 
and also possibly the crypto list 
(see http://vger.kernel.org/vger-lists.html)

Here's the output of checkpatch.pl with your patch:

  total: 15 errors, 29 warnings, 4 checks, 5737 lines checked

The errors need to be fixed or justified; see section 4 of 
Documentation/SubmittingPatches.


- James
-- 
James Morris
<jmorris@namei.org>
