Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYHKWQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYHKWQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYHKWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:15:51 -0400
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:57633 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752911AbYHKWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:15:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=bIv3Ta+rcmxgqcVPQqPEduwuyQN/f3aN/r5m7isiyETzaIT7hZDcI/pjQSgQeDC/a0/qFhC+bDSsl6Qla6Yx+bapFue5XBJbE9WIw+OqLl2nb2huKLlU3U5ZDFltR9HC;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11283] MSI patch blamed for T60p not coming out of suspend to ram
Date: Mon, 11 Aug 2008 15:15:39 -0700
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Matthew Wilcox" <willy@linux.intel.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A._1H.lCjnIB@albercik>
In-Reply-To: <cX_-nNkxKaF.A._1H.lCjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111515.40782.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 9, 2008 3:43 pm Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11283
> Subject		: MSI patch blamed for T60p not coming out of suspend to ram
> Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> Date		: 2008-08-07 16:07 (3 days old)

The fix for this should be in Linus' tree now.

-- 
Jesse Barnes, Intel Open Source Technology Center
