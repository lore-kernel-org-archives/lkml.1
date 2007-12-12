Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbXLLVi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbXLLVi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXLLViU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:38:20 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:20764 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXLLViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PvOF1ZdAC3GoHIakfNKLbAT8S9ct6994VJWOVeQAZdU2/L4j4nHgS4WChR6Yp3xuIcSxWJGVFIRu52ggDs0nKKqgCFtdQfN3nxMShB4aA5i4KX72QW3P0tFbgj1iyJNUORkMrXDyzeUUwat+M9DMr+66BRQaV9ePShuCKXfHD3E=
Message-ID: <3efb10970712121338o363c25ecx254462cc5f096c03@mail.gmail.com>
Date: Wed, 12 Dec 2007 22:38:17 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT] Revert Softdisable for simple irqs.
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <Pine.LNX.4.58.0712121526380.22462@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
	 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
	 <1196176294.13982.58.camel@localhost.localdomain>
	 <1196177122.23808.7.camel@imap.mvista.com>
	 <1196178834.23808.11.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0712121436260.21795@gandalf.stny.rr.com>
	 <3efb10970712121205s7fcda39dt7cfa154c53f3eecb@mail.gmail.com>
	 <Pine.LNX.4.58.0712121526380.22462@gandalf.stny.rr.com>
X-Google-Sender-Auth: 1a5a712105c5f94c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No problem. Could you also ACK the one I sent for mainline.

I will test it first tomorrow morning.

Remy
