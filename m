Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbXGIW7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbXGIW7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbXGIW6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:58:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36230 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbXGIW6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:58:54 -0400
Subject: Re: [PATCH 0/16] Pid namespaces
From: Badari Pulavarty <pbadari@gmail.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <46929540.2090405@fr.ibm.com>
References: <468DF6F7.1010906@openvz.org>
	 <1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>
	 <46929540.2090405@fr.ibm.com>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 16:00:34 -0700
Message-Id: <1184022035.31638.11.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 22:06 +0200, Cedric Le Goater wrote:
> Badari Pulavarty wrote:
> > On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
> >> This is "submition for inclusion" of hierarchical, not kconfig
> >> configurable, zero overheaded ;) pid namespaces.
> > 
> > Not able to boot my ppc64 machine with the patchset :(
> 
> I can't boot either on a x86_64 but I don't even have logs to send :(

Yes. It blew up way early in the boot on my x86_64, so nothing came
up on the console to capture (blank screen) :(

Thanks,
Badari

