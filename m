Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYH0LlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYH0LlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYH0LlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:41:04 -0400
Received: from sacred.ru ([62.205.161.221]:53854 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbYH0LlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:41:02 -0400
Message-ID: <48B53CD8.9070203@openvz.org>
Date: Wed, 27 Aug 2008 15:39:04 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Rex <robert.rex@exasol.com>, Roland McGrath <roland@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pid_ns: kill the now unused task_child_reaper()
References: <20080824154913.GA3786@tv-sign.ru>
In-Reply-To: <20080824154913.GA3786@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 27 Aug 2008 15:39:01 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> task_child_reaper() has no callers anymore, kill it.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
