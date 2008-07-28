Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYG1Oit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYG1Oit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYG1Oik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:38:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYG1Oij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:38:39 -0400
Message-ID: <488DD9D8.7080305@redhat.com>
Date: Mon, 28 Jul 2008 10:38:16 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing: remove unused variable
References: <> <1217158743-12624-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1217158743-12624-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Remove the following warning with CONFIG_TRACING=y:
> 
> 	kernel/trace/trace.c: In function ‘s_next’:
> 	kernel/trace/trace.c:1186: warning: unused variable ‘last_ent’
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>

Thanks!

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve


