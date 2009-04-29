Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbZD2V46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbZD2V46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZD2V4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:56:45 -0400
Received: from trulit.net ([78.46.66.163]:38499 "EHLO mail.elenhost.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbZD2V4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:56:44 -0400
X-Greylist: delayed 1463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2009 17:56:44 EDT
MIME-Version: 1.0
Date: Wed, 29 Apr 2009 23:36:13 +0200
From: <finarfin@dreamos.org>
To: linux-kernel@vger.kernel.org
Subject: =?UTF-8?Q?SCHED=5FEDF=20infos?=
Message-ID: <164c92d827cbee86ba2c5621716309e6@localhost>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm new to this list,

Actually i'm near to BS degree in computer science, and for thesis my
Operating System Professor suggested to complete (or begin?) SCHED_EDF for
linux. 

Now i don't know if i'm able to do that, i'm new to linux-kernel
development:
1. Someone is already working on that? This task is still available?
2. Now there was something implemented about sched_edf?
3. Into sched-rt-groups.txt there was something that was not very clear (in
my opinion): 
   The next project will be SCHED_EDF (Earliest Deadline First scheduling)
to bring
   full deadline scheduling to the linux kernel. Deadline scheduling the
above
   groups and treating end of the period as a deadline will ensure that
they both
   get their allocated time.

   Implementing SCHED_EDF might take a while to complete. Priority
Inheritance is
   the biggest challenge as the current linux PI infrastructure is geared
towards
   the limited static priority levels 0-139. With deadline scheduling you
need to
   do deadline inheritance (since priority is inversely proportional to the
   deadline delta (deadline - now).
   
   Priority inheritance is a different task? 
4. In your opinion three months will be sufficient for that task? (yeah
probably this seems a silly question, but if working on that take me a too
long time i think i have to find another thesis :D i wish to have my degree
before the end of this year)  
5. For implement that algorithm the general EDF documentation will be
sufficient? There are some special requisites?
6. if you have any suggestion i'll be glad to receive it :)

I hope that this mail doesn't sound useless. 

Thank you, 
Ivan


