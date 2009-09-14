Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZINPBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZINPBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZINPBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:01:45 -0400
Received: from fifo99.com ([67.223.236.141]:55414 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703AbZINPBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:01:44 -0400
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Daniel Walker <dwalker@fifo99.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 08:02:29 -0700
Message-Id: <1252940549.28368.255.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 17:34 +0300, Felipe Contreras wrote:
> On Mon, Sep 14, 2009 at 4:55 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Sun, 2009-09-13 at 22:38 +0300, Felipe Contreras wrote:
> >> drivers/acpi/acpica/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
> >> arch/x86/include/asm/string_32.h:74: warning: array subscript is above array bounds
> >>
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >
> > Could you run this through checkpatch also, it looks like you have a few
> > style issues..
> 
> I did... the style issues are already there, my patch is not
> introducing them. Do you want me to send a separate patch to fix the
> existing style issues?

Yes, If your inclined to clean up the whole file, or just the
surrounding code that would be helpful ..

Daniel

