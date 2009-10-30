Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZJ3Aa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZJ3Aa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZJ3Aaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:30:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZJ3Aaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:30:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Oct 2009 09:28:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Juan Miscaro <jmiscaro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to immunize a process from the OOM Killer
Message-Id: <20091030092829.2597646d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <d0626390910291201m6e8121abq831867715f5d7d5@mail.gmail.com>
References: <d0626390910291201m6e8121abq831867715f5d7d5@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 15:01:22 -0400
Juan Miscaro <jmiscaro@gmail.com> wrote:

> Hi, I'm running 2.6.24 on Ubuntu.
> 
> I've got a OOM Killer gone wild.  I have plenty of free memory (over
> 40 GB) and lots of processes are being murdered.  Anyway, I would like
> to first prevent a few processes from being killed in the hopes of
> buying me time (users can work) to discover why the killer is being
> invoked in the first place.

Could you show us your message log of OOM-Killer ?

Thanks,
-Kame

