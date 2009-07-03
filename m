Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZGCGWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZGCGWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZGCGWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:22:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:8001 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZGCGWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PH2lsH6rEEga+z4ds67J8XgroIGW4HKFXNUopfFSWiVZ2IgUMRqeh+EL12mmPXtou6
         O47iNkEhQxjJh0LANHR829lpbl/7ly3dDKe87kiev80TLj9P7UMngzL9vWg6QszliXQE
         Z5KJl9QWOA2pJ1NG8Nb210L87iLW5053N6PpE=
Message-ID: <4A4DA3E0.6050404@gmail.com>
Date: Thu, 02 Jul 2009 23:23:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] SElinux: Fix some typos.
References: <1246556775-8942-1-git-send-email-justinmattock@gmail.com> <1246556775-8942-2-git-send-email-justinmattock@gmail.com> <alpine.LRH.2.00.0907030850500.10242@tundra.namei.org> <4A4D7C94.2020307@gmail.com> <alpine.LRH.2.00.0907031544160.12340@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0907031544160.12340@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 2 Jul 2009, Justin P. Mattock wrote:
>
>    
>> No I will not be afraid of submitting patches, and having them be rejected.
>> all part of the learning curve.
>>      
>
> I'd suggest generally not starting out with spelling, grammatical and
> formatting patches.  It eats reviewer bandwidth, perturbs the codebase
> (causing people working on it to have to update their code) and does not
> give you as much opportunity to to learn about the code.
>
>    
No my intentions were not to eat reviewer bandwidth, or get in the way.
just turned out as I was going through(for example) hooks.c I noticed a 
portion of it
had proper grammar, and then a portion of it seemed as if the author was too
much in a hurry to worry about that.(so I figured hey why not, that's all).
> Try fixing smaller, known bugs or adding small useful changes.
>
> The TODO list for the SELinux kernel code is here:
> http://selinuxproject.org/page/Kernel_Development
>
>    
Thanks for this, Ill have to give this a look and see.

> You can also email the maintainers and ask for suggestions on what to
> tackle.
>
>
> - James
>    
alright James,
Thanks for taking the time
next time I decide to have a major case of
OCD, I'll remember that creating churn is not
a good idea.

Justin P. Mattock
