Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYAJIi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYAJIi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYAJIiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:38:03 -0500
Received: from rosi.naasa.net ([212.8.0.13]:38868 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbYAJIiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:38:00 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 10 Jan 2008 09:37:53 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <20080110073046.GA3432@mail.ustc.edu.cn> <399951601.23683@ustc.edu.cn>
In-Reply-To: <399951601.23683@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801100937.56145.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 10. Januar 2008 schrieb Fengguang Wu:
> On Thu, Jan 10, 2008 at 03:30:46PM +0800, Fengguang Wu wrote:
> > Joerg,
> >
> > Can you try the attached patches? Thank you.
> > I cannot reliably reproduce the bug yet.
>
> Please ignore the first patch and only apply the two debugging
> patches. They will produce many printk messages. The output of
> `dmesg` will be enough for me.

Too late, I'm already compiling the kernel. But I have currently another 
problem, because the iowait problem disappeared today after the regular 
Debian update. I'll try to install the old package versions to make it show 
up again. Maybe that helps to debug it.

Grüße,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

