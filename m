Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbZEHI0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbZEHI0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZEHI0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:26:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:38764 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbZEHI0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:26:21 -0400
Date: Fri, 8 May 2009 18:26:16 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: pavel@ucw.cz, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO] Add garbage collector support.
In-Reply-To: <200905080210.n482ALpZ048382@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.0905081824570.4389@tundra.namei.org>
References: <20090501102438.GA7470@elf.ucw.cz> <200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp> <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp>
 <200905072042.AFF10698.LJFHOOFFQtMOSV@I-love.SAKURA.ne.jp> <alpine.LRH.2.00.0905081140500.2761@tundra.namei.org> <200905080210.n482ALpZ048382@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Tetsuo Handa wrote:

> James Morris wrote:
> > > James, it is possible to apply below commits to security-testing-2.6#next ?
> > > I get a lot of warning messages in my environment.
> > 
> > Please elaborate.
> 
> Without commits
> 
>   mm: pass correct mm when growing stack
>   Revert "kobject: don't block for each kobject_uevent".
>   x86: clean up old gcc warnings
> 
> I get compiler warnings
> 
[...]

Ok, I've merged #next with current Linus.

-- 
James Morris
<jmorris@namei.org>
