Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYALUyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYALUyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbYALUyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:54:32 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:29244 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751463AbYALUyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:54:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=E2xXNwJ0wForROHapuVWBkmgnv3r4gu9GXuUEQkkUvVJGzVAbf6fgo8Vo9uYDt329i9bAxNWEhcg8fP+65xUMnc/N7yBp2U/vMtktes7fz5eDCWWntfBjOKpVwh10lpn5tVVAyFlHvb+r7mSRQW5xOX4oVt8qaGrhzOOifQPuvU=  ;
X-YMail-OSG: nIvDPEgVM1mdbjgauySfNfED4IiDLwW8gmQk1XR4rYW8GUsM4UWaViCwrIk071ruy_tug3_ORw--
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 12 Jan 2008 21:51:02 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 00/21] ide-floppy redux v2
Message-ID: <20080112205102.GB31954@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <200801121446.00276.bzolnier@gmail.com> <200801122114.40047.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801122114.40047.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 09:14:39PM +0100, Bartlomiej Zolnierkiewicz wrote:
[...]

> PS1 Please rebase the patches still needing polishing on top of updated
> IDE quilt tree, recast them and respin the patch series (no need to post
> already merged patches).

sure, will do.

> PS2 what happend to "fix DMA error reporting" patch? (#13 is missing, hmm?)

Yeah, this is strange. It seems git-send-email missed some of the patches. I had
to send #16,#17 manually but didn't notice #13 was also missing. Will send with
the next batch.

-- 
Regards/Gruﬂ,
    Boris.
