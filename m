Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755212AbYLQDSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYLQDSh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbYLQDST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:18:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272AbYLQDSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:18:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, ebiederm@xmission.com, daniel@hozac.com,
        bastian@waldi.eu.org, xemul@openvz.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid
In-Reply-To: Sukadev Bhattiprolu's message of  Tuesday, 16 December 2008 18:06:01 -0800 <20081217020601.GB2866@us.ibm.com>
References: <20081217020601.GB2866@us.ibm.com>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20081217031730.F2767FC3BC@magilla.sf.frob.com>
Date: Tue, 16 Dec 2008 19:17:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Roland McGrath <roland@redhat.com>
