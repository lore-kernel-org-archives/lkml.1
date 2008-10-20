Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbYJTOOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbYJTOOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 10:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYJTOOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 10:14:10 -0400
Received: from bender.cm4all.net ([87.106.27.49]:60636 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYJTOOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 10:14:09 -0400
Date: Mon, 20 Oct 2008 16:12:58 +0200
From: Max Kellermann <mk@cm4all.com>
To: Glauber Costa <glommer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than 120 seconds"
Message-ID: <20081020141258.GA8228@rabbit.intern.cm-ag>
References: <20081017123207.GA14979@rabbit.intern.cm-ag> <20081017143301.GA18522@poweredge.glommer> <20081020065149.GA11213@rabbit.intern.cm-ag> <5d6222a80810200615k60d6f523p9bcd71d8cb070a39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80810200615k60d6f523p9bcd71d8cb070a39@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/10/20 15:15, Glauber Costa <glommer@gmail.com> wrote:
> There's a patch in flight from cyrill that probably fixes your
> problem: http://lkml.org/lkml/2008/9/15/93
> 
> The checks are obviously there for a reason, and we can't just wipe
> them out unconditionally ;-) So can you check please that you are
> also covered by the case provided?

Looks good: booted the machine 30 minutes ago, no problems so far.

Max
