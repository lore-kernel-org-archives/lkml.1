Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbXGJUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbXGJUcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbXGJUcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:32:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49757 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbXGJUcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:32:45 -0400
Subject: Re: [PATCH 0/16] Pid namespaces
From: Badari Pulavarty <pbadari@gmail.com>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <46936DC8.3050602@openvz.org>
References: <468DF6F7.1010906@openvz.org>
	 <1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>
	 <46929540.2090405@fr.ibm.com>  <46936DC8.3050602@openvz.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 13:34:16 -0700
Message-Id: <1184099657.8390.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 15:30 +0400, Pavel Emelianov wrote:
> Cedric Le Goater wrote:
> > Badari Pulavarty wrote:
> >> On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
> >>> This is "submition for inclusion" of hierarchical, not kconfig
> >>> configurable, zero overheaded ;) pid namespaces.
> >> Not able to boot my ppc64 machine with the patchset :(
> > 
> > I can't boot either on a x86_64 but I don't even have logs to send :(
> 
> Neither can I. And I cannot boot clean 2.6.22-rc6-mm1 either :(
> Does someone already know what the reason is?

2.6.22-rc6-mm1 boots fine on my x86-64 machine.

your patches with the fix (in fs/proc/root.c), I am able to
boot my x86-64 machine also.

Thanks,
Badari

