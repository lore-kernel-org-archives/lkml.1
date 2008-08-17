Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYHQMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYHQMP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYHQMPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:15:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbYHQMPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:15:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #11260] Regression: USB memory stick triggers several USB resets before settling with bogus capacity
Date: Sun, 17 Aug 2008 14:18:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.pSG.rbzpIB@albercik> <Pine.LNX.4.64.0808170028550.25704@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808170028550.25704@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171418.27556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Hugh Dickins wrote:
> On Sat, 16 Aug 2008, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11260
> > Subject		: Regression: USB memory stick triggers several USB resets before settling with bogus capacity
> > Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
> > Date		: 2008-08-06 13:33 (11 days old)
> > Handled-By	: Hugh Dickins <hugh@veritas.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=121804333614405&w=2
> 
> James has this fix queued in his scsi-rc-fixes for 2.6.27
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=d211f052fa58a053639bc51501cb64421157d362
> 
> but hasn't asked Linus to pull for a while: I'm hoping it'll get into -rc4.

Thanks for the update.

Rafael
