Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbYAHLlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbYAHLlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761037AbYAHLk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:40:56 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:3901 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbYAHLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vPzV9T0YdFEmdZ9Ys+MGiHN/xsG6I8Rs2U5b06Lsvk2C7Z8pwRH1yq+82Sk/2jo86U6ZhqlCFBB3eyFhy0agfHqP5LadsfR4sBTZNMNJ39yGqn2LBFhsCBWs7/cnvuHEAjAj9JFISaETixuCOBXdpS/FggarIUDosHo7rN6xszA=
Message-ID: <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
Date: Tue, 8 Jan 2008 12:40:54 +0100
From: Matthew <jackdachef@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
In-Reply-To: <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>
	 <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>
	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

sorry for the long delay

- I first had to get home & set up my rig to reproduce this hardlock
(repeatedly hardlocking / shutting down the laptop doesn't do too good
to the new hdd ;) )

and fortunately I was successful :)

sorry for the bad quality of the pics (they were taken with my phone):

http://omploader.org/vYWU1/moto_0025.jpg
http://omploader.org/vYWU2/moto_0026.jpg

steps to reproduce:
1.) log on
2.) startx
3.) opening some pure 64bit apps == working, no locks
4.) opening 32bit-apps (such as firefox-bin, thunderbird-bin) == hard
lock, only pulling power cord (on laptop) or reset button (rig) works,
magic sysrq key doesn't (keyboard & mouse == dead)

I'm currently writing from my "rescue system" (winxp ;) )
so if you need my kernel-config or some more info of the system please tell

Cheers

Mat
