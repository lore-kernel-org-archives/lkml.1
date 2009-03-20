Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZCTQbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZCTQbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZCTQb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:31:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:51496 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZCTQbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tYAKQ1BZ8BsUlhTL+W1FnVBDczxpa9GFyaqyAyUDGedxh2ctXmA+b8bJ2bMzqCwx59
         5kbmmE4aOrxYQNDrfxmWRXoVBZv9F0KjvuNjRfnXQtbKmUh1PhmQik/vnW90SlBAvA9E
         3HM63tSiLdv7xOVClZjLcap78ofq2gJj58pqc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
Date: Fri, 20 Mar 2009 12:31:22 -0400
Message-ID: <f96d234e0903200931w2d57155cm81b67265d42861bf@mail.gmail.com>
Subject: Re: [Announce] 2.6.29-rc78rt1
From: Cliff Brake <cliff.brake@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 8:31 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.

> P.S.: ARM/PowerPC support is in the pipeline and will be available
>      with -rt2 (hopefully :)

Do you have a time estimate for -rt2/ARM support, and is there
anything that can be done to help (testing, etc).

Thanks,
Cliff

-- 
=======================
Cliff Brake
http://bec-systems.com
