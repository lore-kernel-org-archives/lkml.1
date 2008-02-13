Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYBMH15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYBMH15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765973AbYBMH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:27:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57618 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765915AbYBMH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:27:30 -0500
Date: Tue, 12 Feb 2008 23:31:59 -0800
From: Greg KH <greg@kroah.com>
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Mulyadi Santosa <mulyadi.santosa@gmail.com>,
       Peter Teoh <htmldeveloper@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Documentation about sysfs/procfs entries
Message-ID: <20080213073159.GA13414@kroah.com>
References: <804dabb00802112123t774623b2n3e1e0a4addde1512@mail.gmail.com> <b1fc6a560802112217j57ab3fa1h611864a6a2423943@mail.gmail.com> <804dabb00802112346q240745abm93b6257f2cd64e60@mail.gmail.com> <47B15DD2.3090706@gmail.com> <f284c33d0802121808v2e41b648u83070ac1f6f1bb2a@mail.gmail.com> <20080212204348.4a858650.randy.dunlap@oracle.com> <47B2874F.5000805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2874F.5000805@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:59:43AM -0500, Scott Lovenberg wrote:
> Randy Dunlap wrote:
>> On Wed, 13 Feb 2008 09:08:12 +0700 Mulyadi Santosa wrote:
>>
>>   
>>> Hi all...
>>>
>>> Here's my idea: what if we collaborate to extend and make the kernel
>>> documentation better? I have done (slow) start by editing profile=
>>> kernel param. It's not accepted by Adrian Bunk, but at least I did it.
>>> Feedback?
>>>     
>>
>> Adrian is no longer the trivial patch maintainer.
>> Did you send the patch to trivial@kernel.org ?
>>
>> Any doc additions or improvements would be appreciated.
>> I'll be glad to help get them merged...
>>
>> ---
>> ~Randy
>>
>>   
> I'd love to help, but I'm a bit of a newbie; what's protocol for 
> documentation updates, standard diffs?

Yes.

> How are we going to attack this thing, cleaning up and updating existing 
> documentation first and then adding undocumented items, or file by file 
> updating and adding in one fell swoop?

File by file.

And please place the new documentation of sysfs and procfs entries into
the framework in the Documentation/ABI/ directory tree, which is where
it belongs.

thanks,

greg k-h
