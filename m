Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbXGJHFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbXGJHFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762820AbXGJHFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:05:35 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46150 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762795AbXGJHFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:05:34 -0400
Message-ID: <46932FAE.1010809@openvz.org>
Date: Tue, 10 Jul 2007 11:05:18 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>
CC: Cedric Le Goater <clg@fr.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org>	 <1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>	 <46929540.2090405@fr.ibm.com> <1184022035.31638.11.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1184022035.31638.11.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> On Mon, 2007-07-09 at 22:06 +0200, Cedric Le Goater wrote:
>> Badari Pulavarty wrote:
>>> On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
>>>> This is "submition for inclusion" of hierarchical, not kconfig
>>>> configurable, zero overheaded ;) pid namespaces.
>>> Not able to boot my ppc64 machine with the patchset :(
>> I can't boot either on a x86_64 but I don't even have logs to send :(
> 
> Yes. It blew up way early in the boot on my x86_64, so nothing came
> up on the console to capture (blank screen) :(

That's bad news... I will re-check for it. It seems to me that
I lost some parts during the patch splitting... :(

> Thanks,
> Badari
> 
> 

