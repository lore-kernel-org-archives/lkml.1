Return-Path: <linux-kernel-owner+w=401wt.eu-S1763155AbYBFXiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763155AbYBFXiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759185AbYBFXiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:38:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759223AbYBFXiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:38:04 -0500
Date: Wed, 6 Feb 2008 15:36:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stable Team <stable@kernel.org>
Subject: Re: [stable] The SMP alternatives code breaks exception fixup?
In-Reply-To: <20080206231020.GB12395@kroah.com>
Message-ID: <alpine.LFD.1.00.0802061534470.2883@woody.linux-foundation.org>
References: <479504F6.4080005@redhat.com> <p73zluymnx0.fsf@crumb.suse.de> <alpine.LFD.1.00.0801221312200.3199@apollo.tec.linutronix.de> <47964FD5.6020801@redhat.com> <20080206231020.GB12395@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Feb 2008, Greg KH wrote:
> 
> I don't see this in Linus's tree, am I just missing it?  Do you have a
> git commit id?

Isn't this 9d55b9923a1b7ea8193b8875c57ec940dc2ff027 (possibly with 
2532ec6d178abc55681d049097d3dc577eaa266c on top)?

		Linus
