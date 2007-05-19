Return-Path: <linux-kernel-owner+w=401wt.eu-S1764928AbXESWH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764928AbXESWH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764802AbXESWHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:07:07 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:7554 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764793AbXESWHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=L7erCOwkU8FY5LmOv4VF/ZL0rC4ivIkPejMgguVhV4sgdx0vcj3ysCzFk2di+aOWfSiBzQcXKltaIuxrc6Gor6aW/uyXM+tBf6VKXcyY6uwVAB40KBK/VWpGd4+o4pKH/U9XTPlmjv9BbjllPx4623Bs/b2trYkoUom47DOHpF4=
Message-ID: <464F74E9.8080102@googlemail.com>
Date: Sun, 20 May 2007 00:06:33 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Auke Kok <auke-jan.h.kok@intel.com>, Doug Chapman <doug.chapman@hp.com>,
       Jeb Cramer <cramerj@intel.com>, John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       e1000-devel@lists.sourceforge.net, Ben Collins <bcollins@ubuntu.com>,
       yoshfuji@linux-ipv6.org
Subject: Re: [5/5] 2.6.22-rc2: known regressions
References: <464F6DC9.80805@googlemail.com>
In-Reply-To: <464F6DC9.80805@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Networking

Subject    : OOPS triggered by ip(8) deconfiguring a network interface
References : http://bugzilla.kernel.org/show_bug.cgi?id=8491
Submitter  : Ben Collins <bcollins@ubuntu.com>
Status     : Unknown

Subject    : panic with e1000 driver on HP Integrity servers
References : http://bugzilla.kernel.org/show_bug.cgi?id=8455
Submitter  : Doug Chapman <doug.chapman@hp.com>
Caused-By  : Auke Kok <auke-jan.h.kok@intel.com>
             commit e0aac5a289b1dacbc94bd9ae8c449bcdf9ab508c
Status     : problem is being debugged



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
