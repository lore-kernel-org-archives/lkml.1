Return-Path: <linux-kernel-owner+w=401wt.eu-S1422721AbXCWInT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721AbXCWInT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 04:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422720AbXCWInS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 04:43:18 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:58992 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422721AbXCWInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 04:43:18 -0400
Subject: Re: New format Intel microcode...
From: Marcel Holtmann <marcel@holtmann.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 10:43:05 +0100
Message-Id: <1174642985.23136.51.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

> > Is the tool you mentioned last June [1] available for splitting up the
> > old firmware files to the new format (eg
> > /lib/firmware/intel-ucode/06-0d-06), or are updates available from
> > Intel (or otherwise) in this new format?
> Yes, we are preparing the new format data files and maybe put it into a
> new website. We will announce it when it's ready.

please do _NOT_ use any sub-directories in the request_firmware() call.

Regards

Marcel


