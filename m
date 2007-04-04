Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbXDDWew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbXDDWew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXDDWew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:34:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59969 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXDDWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:34:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tilman Schmidt <tilman@imap.cc>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com, Oliver Pinter <oliver.pntr@gmail.com>
Subject: Re: 2.6.21-rc5 possible regression: KDE processes die silently
References: <4601B3D0.3060600@imap.cc> <460FCDE2.1080503@imap.cc>
	<20070402225006.GI14134@stusta.de> <46140B98.1080004@imap.cc>
Date: Wed, 04 Apr 2007 16:30:03 -0600
In-Reply-To: <46140B98.1080004@imap.cc> (Tilman Schmidt's message of "Wed, 04
	Apr 2007 22:33:28 +0200")
Message-ID: <m1mz1n22ok.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt <tilman@imap.cc> writes:

>> We also have another report of crashes under KDE:
>> 
>> Subject    : crashes in KDE
>> References : http://bugzilla.kernel.org/show_bug.cgi?id=8157
>> Submitter  : Oliver Pinter <oliver.pntr@gmail.com>
>
> Could be the same. The report is not detailed enough to say.
> Oliver provokes his crash with amarok which would fit in with
> the sound hypothesis.

Oliver reports the problem not recurring after updating to 2.6.21-rc5-git7.

>> We also have one bug kwin ran into that got fixed after -rc5:
>> 
>> Subject    : kwin dies silently
> [...]
>> Fixed-By   : Eric W. Biederman <ebiederm@xmission.com>
>> Commit     : 14e9d5730adfca26452b3a2838a80af6950556f5
>
> Looks promising. Building -rc5-git12 now. Will test that until
> -rc6 arrives.

Thanks.

Eric
