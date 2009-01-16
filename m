Return-Path: <linux-kernel-owner+w=401wt.eu-S933988AbZAPMvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbZAPMvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbZAPMvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:51:03 -0500
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:63955 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764289AbZAPMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:51:00 -0500
Message-ID: <497081F7.5070007@Calva.COM>
Date: Fri, 16 Jan 2009 13:47:51 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: A patch to arch/i386/kernel/irq.c to help get backtraces of	(near)
 stack overflow situations
References: <49707BA9.1040102@Calva.COM> <20090116123844.GB5421@elte.hu>
In-Reply-To: <20090116123844.GB5421@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> in recent kernel's there's an automatic maximum-stack-footprint tracer 
> plugin available.

Lovely.  Maybe one day I'll be able to use a recent kernel.  :-)

Thanks for the tip.

