Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802Ab0AYNx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0AYNx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555Ab0AYNx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:53:28 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39034 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0AYNx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:53:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mxPMdpajxDXp+cCfL8JFx/QVnO616JoCGeEsUVzKzTW33P1kExEET3kjtg8b2Qzc7R
         1ACb/KdZshfljejQ8NRZavCdF/7dcPbn4IGj1uUulZc8eJmIQ23dKkp3N9EsVjQQ3RUu
         17TktT0RbwGNMsAcK4yqbljrw4b4byd3rddkE=
Date: Mon, 25 Jan 2010 21:55:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David <david@unsolicited.net>
Subject: Re: [Bug #14924] Weird hard hangs when rendering 'some' web-sites
	in Firefox
Message-ID: <20100125135531.GB3749@hack>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.V3G.JLMXLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hE3x9c-4KZM.A.V3G.JLMXLB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:04:33PM +0100, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.32.  Please verify if it still should be listed and let me know
>(either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14924
>Subject		: Weird hard hangs when rendering 'some' web-sites in Firefox
>Submitter	: David <david@unsolicited.net>
>Date		: 2009-12-21 21:53 (35 days old)
>References	: http://marc.info/?l=linux-kernel&m=126143375823340&w=4

Hmm, you have CONFIG_DETECT_SOFTLOCKUP=y, I have no idea what happened,
doing a bisect would be appreciated.

Thanks.

-- 
Live like a child, think like the god.
 
