Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbYBGHTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbYBGHTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYBGHTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:19:47 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:57090 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752935AbYBGHTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:19:46 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-29.messagelabs.com!1202368786!5413171!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Thu, 7 Feb 2008 08:19:42 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP Jornada 7xx handhelds
Message-ID: <20080207071942.GC5235@digi.com>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com> <47A9A944.7090401@tiscali.nl> <47A9AA4F.80508@tiscali.nl> <20080206173341.619c52c8.Kristoffer.ericson@gmail.com> <20080206164435.GC32245@flint.arm.linux.org.uk> <20080206202128.06fbcafa.Kristoffer.ericson@gmail.com> <20080206193155.GE32245@flint.arm.linux.org.uk> <20080206204340.0711c4f6.Kristoffer.ericson@gmail.com> <20080206194557.GF32245@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080206194557.GF32245@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 07 Feb 2008 07:19:42.0697 (UTC) FILETIME=[CF0F9590:01C86959]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15714.002
X-TM-AS-Result: No--11.409100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

> > Doh, right. Do you use a different checkpatch? I mean it doesn't react on
> > that for me.
> 
> No, all of the comments I've given were spotted by merely reading the patch.
May I ask how you spot tab vs. 8 space problems?  Do you apply the patch
and check in an editor?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
