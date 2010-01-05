Return-Path: <linux-kernel-owner+w=401wt.eu-S932209Ab0AEVbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0AEVbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095Ab0AEVbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:31:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19731 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab0AEVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:31:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5852"; a="31444757"
Subject: Re: tree with htc dream support
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <20100102105546.GD9742@elf.ucw.cz>
References: <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
	 <20091227203704.GK11737@elf.ucw.cz> <20091227211322.GB29174@elf.ucw.cz>
	 <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
	 <20091227101824.GB1478@ucw.cz>
	 <a55d774e0912281224y7360dfdbu8a251743026bdd28@mail.gmail.com>
	 <20091228204848.GB1637@ucw.cz> <1262049913.17445.27.camel@desktop>
	 <20100101151818.GI3944@atrey.karlin.mff.cuni.cz>
	 <1262362128.2159.4.camel@m0nster>  <20100102105546.GD9742@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 13:31:12 -0800
Message-ID: <1262727072.19310.16.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-02 at 11:55 +0100, Pavel Machek wrote:
> On Fri 2010-01-01 08:08:48, Daniel Walker wrote:
> > On Fri, 2010-01-01 at 16:18 +0100, Pavel Machek wrote:
> > 
> > > > I have it in my tree already .. My tree has some duplication over
> > > > staging, for instance the rpc code is mostly in my tree, as is the smd
> > > > code.
> > > 
> > > Do you expect you can just merge those for 2.6.34? That would be
> > > great.
> > 
> > I will try ..
> 
> Good.
> 
> How can I check out that tree? I tried pulling from
> git://codeaurora.org/quic/kernel/dwalker/linux-msm.git , but those
> changes do not seem to be there. (I tried default, master and for-next
> branches).

Should be there now .. It's not history stable, or particularly useful
right now .. You can see what's in it tho ..

Daniel

