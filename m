Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYH0LpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYH0LpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYH0LpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:45:03 -0400
Received: from sacred.ru ([62.205.161.221]:47770 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYH0LpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:45:01 -0400
Message-ID: <48B53C98.607@openvz.org>
Date: Wed, 27 Aug 2008 15:38:00 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Rex <robert.rex@exasol.com>, Roland McGrath <roland@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pid_ns: (BUG 11391) change ->child_reaper when init->group_leader
 exits
References: <20080824154912.GA3780@tv-sign.ru>
In-Reply-To: <20080824154912.GA3780@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 27 Aug 2008 15:37:56 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reported-by: Robert Rex <robert.rex@exasol.com>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
