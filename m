Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbYJUGLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbYJUGLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJUGK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:10:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:49689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYJUGK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:10:59 -0400
Message-ID: <48FD71FA.6090102@kernel.org>
Date: Tue, 21 Oct 2008 15:08:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org> <48F308E8.4030503@kernel.org> <20081013142951.GB23124@anita.doom> <48F58A96.8040406@kernel.org> <20081017080840.GB21671@anita.doom>
In-Reply-To: <20081017080840.GB21671@anita.doom>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Oct 2008 06:10:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Hello!
> 
> The patch before, I told it always boots but the last two days I had
> much difficulties to boot. It was hard resetting and waiting a couple of
> times before bailing out with no mountable root FS. 
> 
> One time it was switched off three hours and the next time overnight, I
> powercyced a couple of times. If I am the only one experiencing this
> difficulties (am I the only one with this chipset/revision reporting?),
> shouldn't we consider this machine... broken? I change SATA cables from
> time to time, but these seem all to be okay. I mean, if it is really
> _that_ strange...

Eh... I just bought a used opteron system with nf2/3.  I will receive
the machine tomorrow.  Hopefully, I'll be able find out what the heck is
going on here.

Thanks.

-- 
tejun
