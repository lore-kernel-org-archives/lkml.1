Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZB0NKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZB0NKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 08:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZB0NKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 08:10:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:30346 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZB0NKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 08:10:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oQMny9Uf5ShQsTEXzCWmt34F1ii7sbM9l9AsBKBh7h1+16dJzb6kbreIOl+9CV6gG3
         ZbYFtvvqoQu6TWJVA9nWDvTNoPZ9GK55rm6cDKBrg/mNcPh1f2fqEYdV+/CEcuKNpZ3b
         fjpS1LH+tlqfP8X1QZy24xDl+rIqTH/ujJp0o=
MIME-Version: 1.0
In-Reply-To: <20090227171215.1557.A69D9226@jp.fujitsu.com>
References: <20090227123806.1537.A69D9226@jp.fujitsu.com>
	 <1235722003.4948.1324.camel@laptop>
	 <20090227171215.1557.A69D9226@jp.fujitsu.com>
Date: Fri, 27 Feb 2009 10:10:39 -0300
X-Google-Sender-Auth: 0d6b7c6a15a50b07
Message-ID: <39e6f6c70902270510l1191b500q51427c16722cf6ac@mail.gmail.com>
Subject: Re: [PATCH] new irq tracer
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 5:13 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Fri, 2009-02-27 at 16:48 +0900, KOSAKI Motohiro wrote:
>>
>> > I mean make the patch of mathieu's plan and mesure it. Then
>> > we can mesure number by number. my number mean,
>> >
>> >   (1) How much increasing line and messiness
>> >   (2) How much improving latency
>> >
>> > that's fairly comparision and typical lkml discussion style, imho.
>> >
>> > What do you think?
>>
>> Patches are welcome ;-)
>
> Why sad face? Am I talking about funny thing?

Nope, its just that the way you're talking is looking too managerial.

IOW, instead of proposing measurements, do them and show the results,
how does that sound?

And ;-) is not a sad face in my dictionary, but an ironic one :-)

- Arnaldo
