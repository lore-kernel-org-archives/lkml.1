Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYEEQqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYEEQqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbYEEQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:45:59 -0400
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:56874 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755010AbYEEQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:45:59 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] PCI updates for 2.6.26
Date: Mon, 5 May 2008 09:45:39 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Yinghai Lu <yhlu.kernel.send@gmail.com>, Dave Jones <davej@redhat.com>
References: <200804291012.21832.jbarnes@virtuousgeek.org> <20080429202632.GA4967@elte.hu> <20080429210921.GA24067@elte.hu>
In-Reply-To: <20080429210921.GA24067@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050945.39298.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 2:09 pm Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> > there are a few other PCI items in x86.git btw that you might want to
> > have a look at and which you might want to pick up into your tree -
> > they dont really belong into x86.git.
>
> there's some PCI impact in the "x86 GART" topic tree below, could you
> have a look whether you can see anything objectionable:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-gart.git
> for-linus
>
> if not we'd like to send this to Linus - those changes are stable and
> tested.

Not sure I'm the right person to look at these, but they seem fine to me.

Jesse
