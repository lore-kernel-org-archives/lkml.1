Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbZD0Uts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbZD0Uts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760414AbZD0Uti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:49:38 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:34610 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZD0Uth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xlk0cleWMJSnDrTnowuyjKRKkE7DXOz5tgNRWScoplhfkzdE3YU9bcpOvE7XL7np24
         0RZ41ntUGfCtbe+NP4cJxLQKajQlFU5iBrmh8pecN2X6Bin1DJV2nJMdgYidKFLCtPvC
         HG/bkk4X+qx18ji8qxKYrbqfg/eX2t1Wv9eso=
MIME-Version: 1.0
In-Reply-To: <49F619C4.20100@freescale.com>
References: <20090424183517.GB23140@ovro.caltech.edu>
	 <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>
	 <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>
	 <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com>
	 <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com>
	 <20090427204213.GA4960@ovro.caltech.edu>
	 <49F619C4.20100@freescale.com>
Date: Mon, 27 Apr 2009 13:49:36 -0700
X-Google-Sender-Auth: 7af431ba8325126c
Message-ID: <e9c3a7c20904271349m134ff7f2s9d7901015454cf3d@mail.gmail.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
From: Dan Williams <dan.j.williams@intel.com>
To: Timur Tabi <timur@freescale.com>
Cc: Ira Snyder <iws@ovro.caltech.edu>, David Hawkins <dwh@ovro.caltech.edu>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 1:47 PM, Timur Tabi <timur@freescale.com> wrote:
> Adding Kumar to the CC: list, since he might pick up the patch.
>

Acked-by: Dan Williams <dan.j.williams@intel.com>

I agree with taking this through Kumar's tree.
