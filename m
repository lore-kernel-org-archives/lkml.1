Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXCIRkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXCIRkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXCIRkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:40:40 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:20920 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXCIRkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:40:39 -0500
In-Reply-To: <1173217902.15589.33.camel@sinatra.austin.ibm.com>
To: John Rose <johnrose@austin.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Me Notes <johnrose@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       External List <linuxppc-dev@ozlabs.org>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] ibmebus: dynamic addiiton/removal of adapters,	uevent, root
 device based on struct device
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFAC7B9901.69441F4F-ONC1257299.005F175A-C1257299.006117C1@de.ibm.com>
Date: Fri, 9 Mar 2007 18:40:35 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 09/03/2007 18:40:36,
	Serialize complete at 09/03/2007 18:40:36
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Rose <johnrose@austin.ibm.com> wrote on 06.03.2007 22:51:42:

> We are seeing several build errors when attempting to apply this to
> 2.6.21-rc2:

Hot Damn! I did my test compiles with gcc 3.3, and you obviously compiled 
with gcc 4.1 - I only got a warning where you got an error, and that 
warning escaped me. Sorry about that.

I fixed the error and all warnings and will post a fresh set of patches 
right after this reply. If you could give the new patch another go and ack 
it if it works, I would be delighted! =)

Thanks for pointing this out!
  Joachim

---
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239 

