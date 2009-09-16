Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZIPJTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZIPJTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbZIPJTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:19:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56781 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbZIPJTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:19:36 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [GIT PULL] DRBD for 2.6.32
Date: Wed, 16 Sep 2009 11:19:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <200909151645.14256.philipp.reisner@linbit.com> <20090916094421.DB8F.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090916094421.DB8F.A69D9226@jp.fujitsu.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909161119.36565.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009 02:46:34 KOSAKI Motohiro wrote:
> > Hi Linus,
> >
> > Please pull
> > git://git.drbd.org/linux-2.6-drbd.git drbd
> >
> > DRBD is a shared-nothing, replicated block device. It is designed to
> > serve as a building block for high availability clusters and
> > in this context, is a "drop-in" replacement for shared storage.
> >
> > It has been discussed and reviewed on the list since March,
> > and Andrew has asked us to send a pull request for 2.6.32-rc1.
> >
> > Stephen added us to linux-next in July, and our most recent
> > build failure against Jens' 2.6.32-rc1 updates was ironed out this
> > morning. So it should be in fairly good shape.
>
> I'm sorry for my delayed pointing out.
> if anyone add new feature, its Kconfig default parameter should be N.
>
> but AFAIK, DRBD use M. I hope you change it. At least, typical desktop user
> don't use DRBD.
>
> Thanks.

Ok. I have changed the default to N.

-Phil

