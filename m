Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYHALrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYHALrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbYHALq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:46:28 -0400
Received: from mail.crca.org.au ([67.207.131.56]:35337 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927AbYHALq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:46:27 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 2/6] Container Freezer: Make refrigerator always
	available
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20080801050700.528446138@us.ibm.com>
References: <20080801050659.924495279@us.ibm.com>
	 <20080801050700.528446138@us.ibm.com>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 01 Aug 2008 20:33:11 +1000
Message-Id: <1217586791.27551.24.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2008-07-31 at 22:07 -0700, Matt Helsley wrote:
> Now that the TIF_FREEZE flag is available in all architectures,
> extract the refrigerator() and freeze_task() from kernel/power/process.c
> and make it available to all.
> 
> The refrigerator() can now be used in a control group subsystem
> implementing a control group freezer.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>

Acked-by: Nigel Cunningham <nigel@tuxonice.net>


