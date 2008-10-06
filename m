Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYJFRAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYJFRAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYJFRAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:00:05 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:65260 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYJFRAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UgbD3MLBgnohY50h6KRV9Y+6G6inadVnkha/4uydg1cyRiYinBWZQ57KNv3SKiv3TC
         J2I9hZMYs31RWEXOb439EpF5xvZQKJ2UK12KkusBztAve44HG0JTZKol8TEBxrGUDRJN
         2WKTl9OHWNj0MF3oSU4B+ESd52rsJA6nXF2fg=
From: Andrey Batyiev <batyiev@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: APIC misconfiguration
Date: Mon, 6 Oct 2008 19:55:28 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200810061923.09076.batyiev@gmail.com> <20081006165007.GA7317@localhost>
In-Reply-To: <20081006165007.GA7317@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061955.28915.batyiev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

> actually it's not a bug of APIC itself but rather misconfigured
> device I think. Not sure thru which bus it does work (pci
> i suppose) but I think you better are to fix it on more higher
> level like in config space of this device. PCI guys could tell
> you more about this area I believe.

Device is connected to ISA bus and haven't any autoconfiguration methods.

Thanks,
   Andrey
