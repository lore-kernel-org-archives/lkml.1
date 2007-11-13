Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbXKMVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbXKMVer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761992AbXKMVeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:34:16 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:52566 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760288AbXKMVeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:34:14 -0500
Date: Tue, 13 Nov 2007 13:33:13 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Philip Mucci <mucci@cs.utk.edu>, William Cohen <wcohen@redhat.com>,
       akpm@osdl.org, Robert Richter <robert.richter@amd.com>,
       linux-kernel@vger.kernel.org, Perfmon <perfmon@napali.hpl.hp.com>,
       Andi Kleen <andi@firstfloor.org>, perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>, perfmon@napali.hpl.hp.com
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113213313.GD5747@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113185924.GA22748@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, Nov 13, 2007 at 10:59:24AM -0800, Greg KH wrote:
> On Tue, Nov 13, 2007 at 10:47:45AM -0800, Philip Mucci wrote:
> > Hi folks,
> >
> > Well, I can say the mood here at supercomputing'07 is pretty somber in 
> > regards to the latest exchange of messages regarding the perfmon patches. 
> 
> "somber"?
> 

I am the core developer of this and I am not as pessimistic as Phil. Yet I admit
Phil has been asking for this kind of kernel interface for a very very long time ;-<

> Why?
> 
> We (a number of the kernel developers) want to see the perfmon code make
> it into the kernel tree, unfortunatly, in the current state it is in,
> that's not going to happen.
> 
> Andi specified a way that this can happen, just refactor your patches
> into smaller bits that can be reviewed and applied.
> 

I think I understand your concerns. I will work on this. I think it is possible to
refactor. It will certainly be painful (for me), but I think it can be done within
some reasonable delay. Of course, it would be help if you could better qualify what
you mean by 'smaller'.

> If you, or anyone else has any questions about this, please let us know.
> So far, I have not seen any response to his message, so I'm guessing
> that the perfmon developers either are off working on this, or don't
> care.
> 

I will start working on this once I fix the tickless/hrtimer issues.

> And if they don't care, then yes, I agree with your "somber" feeling...
> 

I do care a lot actually. Believe me, I do spend a lot of effort and energy
on this project everyday, like many others around the world, and I intend for
it to succeed. We have reached a point in the development of processor hardware
where this kind of features is crucial and it is not just for HPC folks anymore.

-- 
-Stephane
