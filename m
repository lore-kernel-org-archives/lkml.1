Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXKMRq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXKMRq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXKMRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:46:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:54246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbXKMRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:46:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OpgisekW9qdfPjyA2Pij0fF66BOCP2Fs+Wla3uk3EzYCJRXlLY/uRdjGBljCIKNGl
	AUtm4MxW40Qv0rOh8LIVw==
Message-ID: <33307c790711130946j3ae10dcx9d776bc9671710f7@mail.gmail.com>
Date: Tue, 13 Nov 2007 09:46:08 -0800
From: "Martin Bligh" <mbligh@google.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [BUG] New Kernel Bugs
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1194968001.3416.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	 <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	 <1194968001.3416.12.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > http://bugzilla.kernel.org/show_bug.cgi?id=9267
> > > Kernel: 2.6.23.1
> >
> > No response from developers
>
> Urm, well, if no-one ever tells the SCSI list it's unrealistic to expect
> anyone to be working on it.  As far as I can tell, email was sent to
> Andrew Vasquez only on 31 October. However, the fault looks to be
> generic, so he probably just dropped it.

This is a technical issue with vger.kernel.org mailing lists that I've tried
addressing before - maybe davem can help fix it?

What I've tried doing is bouncing relevant postings from my procmail
filters to the list, but it seems to drop bounces (probably as spam).
Is there any way around this? (like can I get an exception to be allowed
to bounce stuff or mark it with some magic X-secret-knock: header?)
