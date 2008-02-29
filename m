Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYB2RkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYB2RkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYB2RkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:40:07 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42992 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYB2RkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:40:06 -0500
Date: Fri, 29 Feb 2008 18:40:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 1/3] fix recursive dependencies
Message-ID: <20080229174016.GA5696@uranus.ravnborg.org>
References: <200802210258.45011.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com> <200802242136.28744.yinghai.lu@sun.com> <200802242243.49576.yinghai.lu@sun.com> <20080226194058.GA31438@uranus.ravnborg.org> <Pine.LNX.4.64.0802290443440.2723@scrub.home> <86802c440802282105j2c0d0ce3o551c3afdcc5c2b17@mail.gmail.com> <Pine.LNX.4.64.0802291417140.2723@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802291417140.2723@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 02:22:01PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Thu, 28 Feb 2008, Yinghai Lu wrote:
> 
> > x86: PARAVIRT needed by PARAVIRT_GUEST or X86_VSMP
> > x86: vSMP selection in config
> 
> Sorry, I hadn't seen there already was a followup.
> 
> > in x86.git#testing to use Roman's three patches.
> 
> Only the first patch needs merging, the other two can wait a little.
Agreed. I will take the latter two in kbuild.git.
The first one belong in x86.git.

	Sam
