Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbYI3IRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbYI3IRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYI3IR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:17:28 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:5825 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYI3IR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:17:27 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 04:17:27 EDT
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48E1DC40.2020508@tremplin-utc.net>
Date: Tue, 30 Sep 2008 09:58:56 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>  <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>  <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org> <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com> <alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org> <alpine.LNX.1.10.0809300906550.4022@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809300906550.4022@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina schreef:
> On Mon, 29 Sep 2008, Linus Torvalds wrote:
> 
>>> If it is X related then its both a kernel + X server issue, the e1000e 
>>> driver opens the barn door, the X server drives the horses through it.
>> Are you sure? There was a mandriva report abou NVM corruption on an e100 
>> too (that one apparently just caused PXE failure, the networking worked 
>> fine).
> 
> That is very probably completely separate issue, and shoudl have been 
> fixed already by 78566fecb.
Likely not, you are mentioning a patch for e1000, while the Mandriva bug 
report is about e100:
https://qa.mandriva.com/show_bug.cgi?id=44192

See you,
Eric

