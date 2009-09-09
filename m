Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZIIBUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZIIBUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZIIBUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:20:20 -0400
Received: from fifo99.com ([67.223.236.141]:36205 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZIIBUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:20:20 -0400
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
From: Daniel Walker <dwalker@fifo99.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
In-Reply-To: <4AA701B3.704@cn.fujitsu.com>
References: <4AA70198.9070500@cn.fujitsu.com>  <4AA701B3.704@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 18:20:41 -0700
Message-Id: <1252459241.14793.40.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> +       TP_STRUCT__entry(
> +               __string(       msg,    msg     )
> +       ),

Why the funny spacing here?

Daniel

