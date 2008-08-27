Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYH0Ltg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYH0Ltg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYH0Lt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:49:29 -0400
Received: from sacred.ru ([62.205.161.221]:48449 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbYH0Lt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:49:28 -0400
Message-ID: <48B53C11.2030407@openvz.org>
Date: Wed, 27 Aug 2008 15:35:45 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Rex <robert.rex@exasol.com>, Roland McGrath <roland@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pid_ns: zap_pid_ns_processes: fix the ->child_reaper
 changing
References: <20080824154911.GA3777@tv-sign.ru>
In-Reply-To: <20080824154911.GA3777@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 27 Aug 2008 15:35:44 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
