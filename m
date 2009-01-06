Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZAFSXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZAFSXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZAFSXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:23:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54832
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbZAFSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:23:32 -0500
Date: Tue, 06 Jan 2009 10:23:33 -0800 (PST)
Message-Id: <20090106.102333.261099461.davem@davemloft.net>
To: sam@ravnborg.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, srostedt@redhat.com,
       mingo@elte.hu, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: make proces_ver_nack a bit more readable
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090105200848.GD6204@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
	<20090105200848.GD6204@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 5 Jan 2009 21:08:48 +0100

> On Mon, Jan 05, 2009 at 02:42:59PM -0500, Steven Rostedt wrote:
> > 
> > Impact: clean up
> > 
> > The code in process_ver_nack is a little obfuscated. This change
> > makes it a bit more readable by humans. It removes the complex
> > if statement and replaces it with a cleaner flow of control.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
> 
> And I can confirm the warning has dismissed with this patch.

Applied, thanks everyone.
