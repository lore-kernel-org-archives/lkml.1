Return-Path: <linux-kernel-owner+w=401wt.eu-S1764350AbXJEWft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764350AbXJEWft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 18:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761983AbXJEWfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 18:35:41 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:17331 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbXJEWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 18:35:40 -0400
X-IronPort-AV: i="4.21,237,1188792000"; 
   d="scan'208"; a="41222592:sNHT34185172"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: [PATCH] Replace __attribute_pure__ with __pure
Date: Fri, 5 Oct 2007 18:36:23 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Bryan Wu" <bryan.wu@analog.com>
References: <20071005131309.GA445@linux-mips.org>
In-Reply-To: <20071005131309.GA445@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051836.23936.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 05 Oct 2007 22:35:38.0895 (UTC) FILETIME=[0DDF29F0:01C807A0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 5 Oct 2007 09:13, Ralf Baechle pondered:
> And btw why does Analog list half their employees in the MAINTAINERS
> entry?
> Seems a little over the top ...

Yeah, the original submission got a little carried away...

We can cut that down to just Bryan and the mailing list I think.

-Robin
