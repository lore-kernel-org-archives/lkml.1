Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbXLMRIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbXLMRIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXLMRHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:07:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXLMRHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:07:52 -0500
Message-ID: <476166A6.8070304@redhat.com>
Date: Thu, 13 Dec 2007 15:06:46 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 0/19 -v4] desc_struct integration
References: <11975113122984-git-send-email-gcosta@redhat.com> <1197554287294-git-send-email-gcosta@redhat.com> <20071213164701.GB4865@elte.hu>
In-Reply-To: <20071213164701.GB4865@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
> 
>> Since the last version of it received no comments on the interfaces, 
>> here it goes a version, that I feel ready for inclusion.
>>
>> The comments regarding style, specially the elimination of the 
>> #defines in the desc_struct definition were merged. I also implemented 
>> the vmi functions, missing last time.
>>
>> Ingo, in the absense of further complaints, could you please push to 
>> the x86 tree?
> 
> well i've already included v3 in x86.git (and it's pushed out), and that 
> was looking good already in review and in testing - could you send a 
> v3->v4 delta too?
Sure. The only real difference was Andi suggestion, but it was more 
stylish. Will do soon.

