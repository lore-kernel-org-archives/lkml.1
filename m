Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZA2Ohf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZA2Ohf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZA2Oh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:37:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43274 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbZA2Oh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:37:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: macbook pro radeon suspend issue
Date: Thu, 29 Jan 2009 15:36:37 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49812E3B.6050106@gmail.com>
In-Reply-To: <49812E3B.6050106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291536.37348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Justin P. Mattock wrote:
> No sure if there is a bug report already or not.
> For the macbook pro(ATI chipset) suspend is broken.
> As for kernel version: latest git.
> Last week(before LCA, and during the week, since being no merges.)
> the system would wakeup, show a black screen and sit there. Now
> after a couple of merges have been completed The system wakes up,
> but instantly reboot's.
> 
> I tried to supply any info(ohci1394_dma) when the wakeup occurs, but had 
> no response
> for some reason or another.
> I can try and do a bisect, the only problem
> I have though, is I never labeled good/bad commits(forgot how too);
> 
> In any case If I'm in an urgent need, of having  to suspend
> the system(not in anytime soon at the moment),
> then Ill just revert kernels to one that I know works.     :^)

Which is that?

Rafael
