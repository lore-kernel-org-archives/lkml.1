Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbYAMW4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbYAMW4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYAMW4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:56:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:54017 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbYAMW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:56:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oSI38EN6zOifHohMo6ObjiXZF7SVBMdAcgzKl60ent2kB+EO0qGSR6BFVbrGXlJCl/Y4vZWtFHFz6kBUk+3nClKFFnmXKIy5+3MlELnXraHIn4sdigHyNaCxMhIDwU9hbrHC3PB8WDki3oWclKnohMdmZ3mLyNUUIw8Dp5/02cM=
Message-ID: <5bdc1c8b0801131456h10bb6ab6h7445424c59aeaa26@mail.gmail.com>
Date: Sun, 13 Jan 2008 14:56:22 -0800
From: "Mark Knecht" <markknecht@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc7-rt1
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1200250801.9190.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200250801.9190.7.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 13, 2008 11:00 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> We are pleased to announce the 2.6.24-rc7-rt1 tree, which can be
> downloaded from the location:
>
>   http://rt.et.redhat.com/download/
>

Up and running here. No significant testing but no problems building
it and no obvious regressions from 2.6.24-rc2-rt1.

mark@lightning ~ $ uname -a
Linux lightning 2.6.24-rc7-rt1 #1 PREEMPT RT Sun Jan 13 14:41:21 PST
2008 x86_64 AMD Athlon(tm) 64 Processor 3000+ AuthenticAMD GNU/Linux
mark@lightning ~ $

- Mark
