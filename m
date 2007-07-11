Return-Path: <linux-kernel-owner+w=401wt.eu-S1764924AbXGKOjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764924AbXGKOjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760736AbXGKOjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:39:22 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:41939 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692AbXGKOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:39:21 -0400
Date: Wed, 11 Jul 2007 10:39:18 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, Steve Beattie <sbeattie@suse.de>
Subject: Re: [PATCH 1/1] file capabilities: clear caps cleanup
In-Reply-To: <20070711141850.GA6690@sergelap.austin.ibm.com>
Message-ID: <Line.LNX.4.64.0707111038500.23589@d.namei>
References: <20070711141850.GA6690@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Serge E. Hallyn wrote:

> >From 88115394044e697ac852f7fb9f30483e87f4f598 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 11 Jul 2007 10:01:01 -0400
> Subject: [PATCH 1/1] file capabilities: clear caps cleanup
> 
> As suggested by Steve Beattie, rather than jump into a
> conditional block in certain cases, define and use a
> static inline bprm_clear_caps().
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Good idea.

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
