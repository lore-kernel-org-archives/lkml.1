Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZEHBnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZEHBnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZEHBnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:43:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:36305 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbZEHBnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:43:22 -0400
Date: Fri, 8 May 2009 11:43:17 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: pavel@ucw.cz, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO] Add garbage collector support.
In-Reply-To: <200905072042.AFF10698.LJFHOOFFQtMOSV@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.00.0905081140500.2761@tundra.namei.org>
References: <20090501102438.GA7470@elf.ucw.cz> <200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp> <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp>
 <200905072042.AFF10698.LJFHOOFFQtMOSV@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Tetsuo Handa wrote:

> Now, TOMOYO can release memory. :-)
> 
> Attached patch is for security-testing-2.6#next.
> James, it is possible to apply below commits to security-testing-2.6#next ?

It's an invasive patch.  How much testing and review has this had by your 
team?

> I get a lot of warning messages in my environment.

Please elaborate.


- James
-- 
James Morris
<jmorris@namei.org>
