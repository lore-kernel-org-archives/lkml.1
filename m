Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZBYSel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZBYSel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZBYSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:34:31 -0500
Received: from www17.your-server.de ([213.133.104.17]:58933 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZBYSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:34:31 -0500
Subject: Re: [Announce] 2.6.29-rc6-rt3
From: Thomas Meyer <thomas@m3y3r.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 20:34:04 +0100
Message-Id: <1235590444.3907.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 24.02.2009, 18:57 +0100 schrieb Thomas Gleixner:
> We are pleased to announce the next update to our new preempt-rt
> series. It contains only one new patch:
>   
>   - fix the nf_conntrack bug, which was reported by various folks
> 
> Download locations:
>  
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
>   
> Information on the RT patch can be found at:
> 
>     http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.29-rc6-rt3 tree, the following patches should be
> applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc6.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc6-rt3.bz2
>   
> The broken out patches are also available at the same download
> locations.
> 
> Enjoy !
> 
>       tglx

Hi,

Should suspend&resume to ram work with this patchset applied?

greets
thomas


