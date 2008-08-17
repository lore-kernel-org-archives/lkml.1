Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYHQPDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYHQPDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYHQPDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:03:36 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51018 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYHQPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:03:35 -0400
Subject: Re: [Bug #11260] Regression: USB memory stick triggers several USB
	resets before settling with bogus capacity
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
In-Reply-To: <Pine.LNX.4.64.0808170028550.25704@blonde.site>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.pSG.rbzpIB@albercik>
	 <Pine.LNX.4.64.0808170028550.25704@blonde.site>
Content-Type: text/plain
Date: Sun, 17 Aug 2008 10:03:27 -0500
Message-Id: <1218985407.3917.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-17 at 00:33 +0100, Hugh Dickins wrote:
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

Yes ... sure.  linux-next has slowed my push to rcs because it's in
there as soon as it's in my git tree.  However, give it a couple of days
to test out the rest of the fixes in the tree and I'll send a push
request.

James


