Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYCEReF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYCEReF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbYCERdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:33:46 -0500
Received: from gw.goop.org ([64.81.55.164]:40039 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760887AbYCERdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:33:45 -0500
Message-ID: <47CED834.8020207@goop.org>
Date: Wed, 05 Mar 2008 09:28:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Eduardo Habkost <ehabkost@redhat.com>, Ian Campbell <ijc@hellion.org.uk>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
 to 1MB
References: <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <20080305155930.GI20230@blackpad> <47CEC561.6050008@zytor.com> <20080305165320.GJ20230@blackpad> <47CED853.6030909@zytor.com>
In-Reply-To: <47CED853.6030909@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> x86 has a number of historical assumptions, both in kernel and in 
> userspace (consider dmidecode!)  Trying to go against them is a losing 
> proposition, *AND* a headache for the maintainers, which will have to 
> consider "oh yes, and Xen does this dumb thing which goes against what 
> all the hardware does."

Ahem.  "Hardware does this dumb thing that Xen avoids".  kthxbye ;)

    J
