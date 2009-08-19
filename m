Return-Path: <linux-kernel-owner+w=401wt.eu-S1751075AbZHSBRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbZHSBRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZHSBRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:17:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:23378 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZHSBRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mKMcthBt7Ki14Lq35RKe8Vh9i0nRliHnKMZfGYL7jjlr0V/GSNxdX8x8wsHRBQs52u
         u2mxjExt2dWSClAE1nwHPnqwN/02L3l0iqaMnXirayLUSIXdqOu3zYqOKBAR6OEr5tWd
         Y9a11LV/ww2aUDpucu+A/M2N1uJRLuUnkJbjc=
Message-ID: <4A8B52CF.4030807@gmail.com>
Date: Tue, 18 Aug 2009 18:18:07 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com> <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com> <4A8B4607.6090303@gmail.com> <alpine.DEB.2.00.0908182030450.18648@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908182030450.18648@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 18 Aug 2009, Justin P. Mattock wrote:
>    
>> well grub2 sure works o.k.
>> the new gfxload is pretty good.
>> problem is the screen just says
>> [Linux-bzImage etc.....]
>> and that's it. (was hoping to make the
>> font smaller to reveal the bug).
>>
>> at this point the only choice I have is to undo
>> commits until I hit the right one.
>>      
>
> How come you can not do a git bisect?
>
> It would be faster.
>
> -- Steve
>
>
>    
I'll give it a try


Justin P. Mattock
