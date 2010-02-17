Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0BQQPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:15:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59138 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0BQQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GMsDmUEyGj3XFRpXUkQf73NELs278MXAAHOAcsp8lrKGTQjjqMDKLtqS/5IuMgiBCl
         VwGIInjQUAVsbL9VsjeYH4I+WxFtIZ6rH+qHruXzbyaHtNOc/KPogR6hSCTTKLNCTbxc
         S5q8EPMNmmdjuaVPrtpiBo5jZ1nsWNLWyecu8=
Date: Wed, 17 Feb 2010 17:15:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Michael Stefaniuc <mstefani@redhat.com>
Subject: Re: [Bug #15273] Regression in ptrace (Wine) starting with
	2.6.33-rc1
Message-ID: <20100217161543.GB5041@nowhere>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera> <4un6Gst5rKB.A.j0G.oiIeLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4un6Gst5rKB.A.j0G.oiIeLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:38:35AM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15273
> Subject		: Regression in ptrace (Wine) starting with 2.6.33-rc1
> Submitter	: Michael Stefaniuc <mstefani@redhat.com>
> Date		: 2010-02-11 16:21 (4 days old)


We are taking care of it. It's actually two regressions.
One has a fix that seems to work, and I'm working on the other one,
trying to get that upstream before 2.6.33 gets released.

Please keep the ticket open for now.

Thanks.

