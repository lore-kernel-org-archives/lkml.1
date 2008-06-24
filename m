Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbYFXOqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbYFXOqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbYFXOqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:46:23 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:44973 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757833AbYFXOqW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:46:22 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-rt-users@vger.kernel.org
Date: Tue, 24 Jun 2008 16:46:07 +0200
User-Agent: KMail/1.9.4
Cc: "Gregory Haskins" <GHaskins@novell.com>, mingo@elte.hu,
       rostedt@goodmis.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <4860CD0B0200005A0003944C@sinclair.provo.novell.com> <4860CD140200005A0003944F@sinclair.provo.novell.com> <4860CD140200005A0003944F@sinclair.provo.novell.com>
In-Reply-To: <4860CD140200005A0003944F@sinclair.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806241646.08335.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: 2.6.25.8-rt7
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 16:31, Gregory Haskins wrote:
> I believe this is my fault.  You must be building for uniprocessor?  Ingo
> has a fix for this issue in sched-devel that should be pulled into -rt.

I can avoid this failure, when I disable the "Group scheduling for 
SCHED_RR/FIFO" menu entry. Don't know the impact.

Juergen

-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
