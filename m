Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbXE1WNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbXE1WNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXE1WNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:13:00 -0400
Received: from sd-green-bigip-145.dreamhost.com ([208.97.132.145]:36073 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752011AbXE1WM7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:12:59 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: NOHZ: local_softirq_pending 08
Date: Tue, 29 May 2007 03:42:41 +0530
User-Agent: KMail/1.9.6
Cc: =?iso-8859-2?q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
References: <465B43D6.6060405@interia.pl>
In-Reply-To: <465B43D6.6060405@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705290342.42175.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 02:34:22 Rafa³ Bilski wrote:
> Hi!
>
> A lot of "NOHZ: local_softirq_pending 08" messages (about 100) and
> then suddenly stoped to show. I have 2.6.21.1. I checked .2 and .3
> changelogs but I don't see anything about this message.
> What does it mean?
>
> Is "08" IRQ number?
>   8:          2    XT-PIC-XT        rtc
>
> Please CC me.
Does this patch [ http://lkml.org/lkml/2007/5/22/35 ] helps you fix it ?

Regards 
Ananitya


-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
