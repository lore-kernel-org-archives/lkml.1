Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbYBFA0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbYBFA0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYBFA0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:26:09 -0500
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:26602 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753991AbYBFA0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:26:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qx+IXFLcP3Bu+64zEMMbhC1TOa4E8g0bbzS0KWIpw5T5EpxYchQtMqVsR9xZdWMT0OBs1HMgmrZroDLsXk/y03aJHne05X8WVLQ1xG6WHLMNVVkorP2QyJSoplHEj0DQ95zCrUjJvz4h+D7vhJdQj8T8l9ujKPjlimzoPmVpNCw=;
X-YMail-OSG: JF1YVfEVM1lXDfCGy1ysum8mns8PTv_GHEH1fXapHhv0BFhwcT8QVpoMaNlpOtPr2l7y99HOAiOwP18ccbWDOq7NYn23OnO2uig7aoHy8pO5x8TPVSZkliI7nELpCw--
Date: Wed, 6 Feb 2008 00:26:05 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] 2.6.24 refuses to boot - NMI watchdog problem?
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080205153243.dadaace8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <658272.2386.qm@web52902.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 2 Feb 2008 23:36:42 +0000 (GMT)
> Chris Rankin <rankincj@yahoo.com> wrote:

> > I have a 1 GHz Coppermine PC with 512 MB RAM, and it is failing to boot with the
> nmi_watchdog=1
> > option. This kernel was rebuilt after doing a "make mrproper". The dmesg log follows:
> 
> Can you tell us if earlier kernels worked OK, and if so which version(s)?
> From your other mail it appears that 2.6.23 was OK?

Oh yes, 2.6.23.14 is fine with nmi_watchdog=1. (This is on a UP machine with a SMP/PREEMPT kernel,
BTW. "Just for fun.")

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

