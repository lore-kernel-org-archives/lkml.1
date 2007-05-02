Return-Path: <linux-kernel-owner+w=401wt.eu-S2993222AbXEBOMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993222AbXEBOMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993223AbXEBOMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:12:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993222AbXEBOMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:12:12 -0400
Message-ID: <46389BBF.5000508@redhat.com>
Date: Wed, 02 May 2007 10:10:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge plans)
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org> <463688AD.1050903@garzik.org> <20070501004036.GS2819@sequoia.sous-sol.org> <46368DA5.7070003@garzik.org> <20070501045806.GA3697@kroah.com> <46376748.6020408@redhat.com> <20070501174033.2046f289@the-village.bc.nu> <20070501233419.GA10462@kroah.com> <20070502005212.GY2819@sequoia.sous-sol.org>
In-Reply-To: <20070502005212.GY2819@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Greg KH (greg@kroah.com) wrote:
>> And is this really a problem?  The whole goal of the -stable tree was to
>> accomidate the users who relied on kernel.org kernels, and wanted
>> bugfixes and security updates.  It was not for new features or new
>> hardware support.
>>
>> If people feel we should revisit this goal, then that's fine, and I have
>> no objection to that.  But until then, I think the rules that we have
>> had in place for over the past 2 years should still remain in affect.
> 
> I have to agree.  I went back through my mbox and found vanishingly few
> pci_id update patches.   So it's not clear there's even a big issue.
> 

Of course you didn't find many -- most people know that's not part of
the -stable charter. If you asked for them you'd get them...
