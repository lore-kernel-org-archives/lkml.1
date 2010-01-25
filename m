Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665Ab0AYNlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0AYNlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540Ab0AYNlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:41:45 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:47158 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0AYNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Sr8e68GPG56l0tVysIJTAWTsjfnomivol3DiCM5lWybx/dFYu6yq4CGRycGGp1dRDt
         vPBVomvY7+vOLMiNHZHBpIRP5/vqwrO+qN0BVglY8HEzg4w1nYo0DtSjfi1Voaafa45k
         fDUPcoe5EoBUWNGTz7eVoAIu0tM9nDWl/amdE=
Date: Mon, 25 Jan 2010 21:43:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Bug #15137] NULL pointer dereference in vlan_skb_recv
Message-ID: <20100125134346.GA3749@hack>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.W0E.4JMXLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hE3x9c-4KZM.A.W0E.4JMXLB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:04:41PM +0100, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.32.  Please verify if it still should be listed and let me know
>(either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15137
>Subject		: NULL pointer dereference in vlan_skb_recv
>Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
>Date		: 2010-01-23 15:56 (2 days old)
>References	: http://marc.info/?l=linux-kernel&m=126426286507497&w=4
>Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
>Patch		: http://patchwork.kernel.org/patch/74999/
>		  http://patchwork.kernel.org/patch/75002/
>

This one can be closed, patch from Eric is already applied by David Miller.


-- 
Live like a child, think like the god.
 
