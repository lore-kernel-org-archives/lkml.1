Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbXKWATh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbXKWATh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXKWATa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:19:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbXKWAT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:19:29 -0500
Date: Thu, 22 Nov 2007 16:18:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <k.shutemov@velesys.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071122161826.61515a6d.akpm@linux-foundation.org>
In-Reply-To: <20071122102205.GD7085@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071122102205.GD7085@localhost.localdomain>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 12:22:05 +0200 "Kirill A. Shutemov" <k.shutemov@velesys.com> wrote:

> On x86_64 'uname -m' return 'x86'.  It break many userspace programs. apt
> and rpm for example.
> 

Yes, there have been various discussions about this.  I think Sam is cooking up
a fix?
