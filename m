Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYJARIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYJARIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYJARIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:08:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:62670 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYJARII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qzNuX69eo/DfSqrw5NWOeOkgmFDQ5T5maKjK3siXXee2QkwUuIEeQqvHzg/UVjzEmD
         /dSLXrXlIZPq4A+r6fTlace6XVIZBDwGHbtB/+0WxaPbIj59to+l1zOTJNI2fuQRroya
         SRRRMVNGFqLBKOC4U1n2pRX3YlRWsyYGW2oK0=
Message-ID: <c62985530810011008t45d3b1b6wafc80d15d2db1a7a@mail.gmail.com>
Date: Wed, 1 Oct 2008 19:08:04 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/2] ring_buffer: updates for linux-tip
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Pekka Paalanen" <pq@iki.fi>, "Martin Bligh" <mbligh@google.com>
In-Reply-To: <c62985530810010532p4ccd7124l601b575fa1e3778d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081001042951.412019606@goodmis.org>
	 <c62985530810010020u1f3f44e1l6b8fb2f31c35d215@mail.gmail.com>
	 <20081001072300.GD9366@elte.hu>
	 <c62985530810010532p4ccd7124l601b575fa1e3778d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/1 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2008/10/1 Ingo Molnar <mingo@elte.hu>:
>> are the tracer problems you've reported yesterday fixed in latest
>> tip/master?
>
> I will not have time to check until this evening. So I will report any potential
> feedback tomorrow.

Ok I just tested and it's fixed now.

Thanks Steven :)
