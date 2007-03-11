Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXCKFUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXCKFUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 00:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXCKFUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 00:20:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:57493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbXCKFUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 00:20:17 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
To: Sam Ravnborg <sam@ravnborg.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sun, 11 Mar 2007 06:21:59 +0100
References: <7X9Ep-6Iu-1@gated-at.bofh.it> <7XcsC-2Iz-3@gated-at.bofh.it> <7XcCq-2VQ-15@gated-at.bofh.it> <7Xd5o-3wR-15@gated-at.bofh.it> <7Xd5o-3wR-13@gated-at.bofh.it> <7Xe1t-52k-11@gated-at.bofh.it> <7XeE6-67b-1@gated-at.bofh.it> <7XhiJ-1UJ-15@gated-at.bofh.it> <7Xhsk-26S-9@gated-at.bofh.it> <7Xiy3-3MW-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HQGVL-0000mI-Oi@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1/Mk4+fPKg+hu0PvN+TrbejG2naQWtJS4EQeOE
 UexTrYuM4H9ZMpf7NA+KDRtqH7Pmj33ZTBJtJB636MShcD3IT6
 ssWnmKq9t26Tb3T3KKokQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, Mar 10, 2007 at 10:34:41PM +0100, Jan Engelhardt wrote:
>> On Mar 10 2007 22:27, Sam Ravnborg wrote:
>> >On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:

>> >> Whether the 'working config file path' should change when you do
>> >> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
>> >> if you want it changed :-)
>> >
>> >Current behaviour is not logical but on the other hand I do not
>> >see a big need to make it so.
>> >It seems that people very seldom uses "save alternate" anyway.
>> >
>> >But patches are welcome.
>> 
>> ^_^ The patch has already been posted, has not it?
> No.
> Either we keep current behaviour

, which is misleading,

> or we change to the "normal"
> behaviour with a "Save as..." as know from all other programs.

, which is not desirable, as long as there is no "open" and "save" option
also working as "normal".

IMO the option should have the "Save a copy" semantics, since that's what the
name suggests.
-- 
Top 100 things you don't want the sysadmin to say:
51. YEEEHA!!!  What a CRASH!!!

Friﬂ, Spammer: WCD1@7eggert.dyndns.org c0DSB5Uh7w@7eggert.dyndns.org
