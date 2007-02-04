Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbXBDXEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbXBDXEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 18:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXBDXEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 18:04:34 -0500
Received: from main.gmane.org ([80.91.229.2]:42750 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbXBDXEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 18:04:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: Free Linux Driver Development!
Date: Sun, 4 Feb 2007 23:04:15 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnescq4c.90j.olecom@flower.upol.cz>
References: <1605445807@web.de>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, devzero@web.de, greg@kroah.com
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: devzero web.de
> Newsgroups: gmane.linux.kernel
> Subject: Re: Free Linux Driver Development!
> Date: Sun, 04 Feb 2007 22:37:33 +0100
> Organization: http://freemail.web.de/
> Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/489586>

> First off, compliments to this announcement, I liked it very much!
>
> Some comment regarding those "volunteers, waiting to get some real work" :)
>
>> > OK, but why isn't your army of volunteers fixing them?
>
>> They don't know about them, or they don't have the hardware to test?
>> Seriously, let the kernel-janitor's project know about any issues you
>> have and they will be glad to jump on it.  Those people are just
>> chomping a the bit to do something a bit bigger than "compiler warning
>> cleanups" :)
>
> So many times i have seen good ideas brought up, kernel patches being written, posted to lkml, being developed outside mainline for a while and then being forgotten some time later due to lack of energy of some individual to get this into mainline.
>
> If there is an noticeably number of talented programmers (unfortunately, i`m not) , so why not "feeding" them the right way ? Where is those public and transparent and moderated Linux-Kernel "ToDo"- or "Keep an eye on"-list, sorted by priorities, with sort of a "vote for this feature"-button, so those guys have something they can pick up? There is so much great stuff and ideas out there where they could put their work onto or getting involved, it just needs to be found or sort of being "managed" a little bit better.
>
> For myself, i`m waiting for so quite some things to get "one step further", but they are more or less tied to some single individuals, for which you just cannot send some "hey, what`s up with your project"-message every second day. The interest in many nice projects often is quite low and evolution quite slow, but not only because of the fact that they aren`t great, but more because of not getting widely known. It`s not always missing specs, it`s also some missing noise/feedback for different features or missing of some "driving force" to bring things forward. How should one developer know that somebody needs a feature if those who could probably need it don`t request it? Maybe just because of the fact that they even imagine that such feature would be possible ?
>
> Where is those efforts for fixing/integrating fantastic cowloop?
> What about badram/badmem patch ?
> Compressed Ccaching ?
> Somebody helping with development of dm-loop or extend loop.c to support more than 256 devices ?
> Replacement of proprietary, unstable and unelegant vmware-lopp for being able to mount vmware .vmdk files ? Internal Spec for this is open, dm-userspace could be some infrastructure for this, but the author seems to have other priorities....
> dm-cow, zfs-fuse - anybody ?
> Kernel based target for AoE (Ata over Ethernet) ?  (there are two independent implementations, but both got stuck at some early experimental stage) 

A quick answer for philosophers:
  	       <http://www.linuxjournal.com/article/7272>

For example, i don't know if somebody volunteered to be a bug-buddy in
google, see Andrew's 2.6.20-rc6-mm1 announcement. It seems no, as he
still forwards bugzilla reports to developers/maintainers.

I myself am new. But anyway, i can write a little bit of HOWTO

-- effectively handle (among others) LKML, to break free from myths,

-- to not afraid emacs as good editor for issues like symbol-searching (TAGS),
   whitespace, spell (typos) and such,

-- having linux tree up-today with small bandwidth: mirrors, patches, quilt

of course if such things prevent people from participating.

[:(ot) As for Greg's message, imho somebody was bored. There is plenty  ;]
[: of work *in* the kernel, not only in drivers/ related part of it...  ;]

> Just my 2 cents. 

So my.


Greetings.
--
-o--=O`C  info emacs : not found  /. .\ ( is there any reason to live? )
 #oo'L O  info make  : not found      o (    yes --- R.I.P. FSF+RMS    )
<___=E M  man gcc    : not found    `-- ( viva Debian Operating System )

