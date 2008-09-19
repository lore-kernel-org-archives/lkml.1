Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYISWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYISWJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYISWJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:09:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYISWJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:09:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=F4CB7Ff20IpvQpitFwFBRJnc79DNZmEF95Aw4uxZiAItzA+dT5T62QyewMJo1eGHI
	eSJvKKYIYavkESBtakPUw==
Message-ID: <33307c790809191509u46430137x641d0f1501f30251@mail.gmail.com>
Date: Fri, 19 Sep 2008 15:09:00 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Martin Bligh" <mbligh@google.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Cc: "Olaf Dabrunz" <od@suse.de>
In-Reply-To: <20080919222854.GA4491@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <20080919222854.GA4491@suse.de>
X-GMailtapped-By: 172.25.146.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> /debugfs/tracing/<name>/buffers/enabed         <--- binary value
>
> ASCII "0" and "1"?

Oops. s/binary/boolean/ and yes, in ASCII.
