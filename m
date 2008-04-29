Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYD2WfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYD2WfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYD2Wey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:34:54 -0400
Received: from outbound-mail-154.bluehost.com ([67.222.39.34]:42604 "HELO
	outbound-mail-154.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753918AbYD2Wex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:34:53 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86/pci: remove flag in pci_cfg_space_size_ext
Date: Tue, 29 Apr 2008 15:34:38 -0700
User-Agent: KMail/1.9.9
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080426185516.GA32364@elte.hu> <200804290914.16742.jbarnes@virtuousgeek.org> <20080429220529.GG2302@elte.hu>
In-Reply-To: <20080429220529.GG2302@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291534.39067.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 3:05 pm Ingo Molnar wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Monday, April 28, 2008 4:27 pm Yinghai Lu wrote:
> > > so let pci_cfg_space_size call it directly without flag.
> > >
> > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> > Thanks Yinghai.
> >
> > Ingo, I assume you'll roll this in?
>
> no, i sent the tested tree to Linus, which was unmodified from 3 days
> ago. Could you queue up this cleanup into the PCI tree please?

Sure, np.  Applied.  Thanks Yinghai.

Jesse
