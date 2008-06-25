Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYFYLtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYFYLtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYFYLtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:49:23 -0400
Received: from gw.goop.org ([64.81.55.164]:36590 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873AbYFYLtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:49:22 -0400
Message-ID: <4862309E.601@goop.org>
Date: Wed, 25 Jun 2008 07:48:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 36 of 36] x86_64/paravirt: Make load_gs_index() a	paravirt
 operation
References: <patchbomb.1214367536@localhost> <30130237d2ea98577dd4.1214367572@localhost> <20080625084700.GB11524@elte.hu>
In-Reply-To: <20080625084700.GB11524@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>     
>
> patch logistics detail: the signoff order suggests it's been authored by 
> Eduardo - but there's no From line to that effect - should i change it 
> accordingly?

Yes, it's Eduardo's.  Huh, I have the From line here; must have got 
stripped off by my script...

    J

