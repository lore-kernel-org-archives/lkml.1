Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYAQF0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYAQF0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 00:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYAQF0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 00:26:42 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:3780 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYAQF0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 00:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vHtsXQwnaP6sxMhE7/++N/vMbrwI3pCfcIpIqARatQLXpqqO6+W3FriDcoCNZSHiZ6q8lL7D2+XKbvRtyeqm5suI3H8mhOfCK5ooKwAvJtArk5ZJSyu2krtL0jeZEHe3GyrDduDnx+RKy2Mc5zC0LkfwwRKrnwYM4q2rdzW8Wzc=
Message-ID: <5bdc1c8b0801162126i115ba2d0rc47f6651fda1c10a@mail.gmail.com>
Date: Wed, 16 Jan 2008 21:26:39 -0800
From: "Mark Knecht" <markknecht@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc8-rt1
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1200544050.318.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200544050.318.18.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 8:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> We are pleased to announce the 2.6.24-rc8-rt1 tree, which can be
> downloaded from the location:
>
>   http://rt.et.redhat.com/download/
>

Up and running fine here:

mark@lightning ~ $ uname -a
Linux lightning 2.6.24-rc8-rt1 #1 PREEMPT RT Wed Jan 16 21:11:05 PST
2008 x86_64 AMD Athlon(tm) 64 Processor 3000+ AuthenticAMD GNU/Linux
mark@lightning ~ $

Cheers,
Mark
