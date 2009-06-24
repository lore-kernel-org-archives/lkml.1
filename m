Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZFXVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZFXVcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFXVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:32:14 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:59904 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZFXVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aRsNJOL7ms3196OqGIlPFLITgmP4EcBZ9yhQExSi35Nj7noYIy9J6MJrgGcFDItG61
         1g+uOP10IsrnyJIRoT4xzQpjYr2Y0etxuZtnYeyY2EfWqBicDMhm3WPNBu82WdsFZObI
         5e+AkxmO5bX+wliNJoCqvWKpvz8VnjP3Wi9/4=
MIME-Version: 1.0
In-Reply-To: <4A4286F8.9020501@lwfinger.net>
References: <1245845787.3093.3.camel@localhost.localdomain>
	 <1245859068.3216.5.camel@localhost.localdomain>
	 <20090624161306.GC7239@us.ibm.com>
	 <1245861219.3216.15.camel@localhost.localdomain>
	 <20090624094411.08fc66e6@jbarnes-g45>
	 <20090624175513.GE7239@us.ibm.com>
	 <20090624112849.55b38fff@jbarnes-g45>
	 <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>
	 <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net>
Date: Wed, 24 Jun 2009 14:32:15 -0700
Message-ID: <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please fix the whole boot log with debug.

need to make sure how many HT chain in your system.

YH
