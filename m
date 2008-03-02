Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYCBOT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYCBOT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 09:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYCBOTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 09:19:50 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:35452 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYCBOTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 09:19:50 -0500
Date: Sun, 2 Mar 2008 15:17:06 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Adam Belay" <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080302151706.4f99dda9@mjolnir.drzeus.cx>
In-Reply-To: <75b66ecd0803011827qd64e1f2ud593fedbec33abe9@mail.gmail.com>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
	<75b66ecd0803011827qd64e1f2ud593fedbec33abe9@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008 21:27:09 -0500
"Lee Revell" <rlrevell@joe-job.com> wrote:

> 
> Should there be a comment stating the motivation for the change?

In the code you mean? Yes, that will be added.

> 
> Thanks for trying to address this problem, I know many users who are afflicted.
> 

As always, the quickest way to get things done is to make sure a kernel developer suffers from the same issue. ;)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
