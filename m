Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbZG3BuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbZG3BuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZG3BuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:50:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61666 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZG3BuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:50:17 -0400
Message-ID: <4A70FBFE.8060206@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 09:48:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing: Various cleanups for 2.6.32
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Hi Thomas, Ingo,
> 
> These patches are the result of various cleanups in the tracing
> subsystem: algorithms simpifications, and various trace.c to tracer
> files moving.
> 

It's good to see trace.c shrinks a bit. :)

