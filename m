Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXKGRuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXKGRuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXKGRua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:50:30 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:62287 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009AbXKGRu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:50:29 -0500
Date: Wed, 7 Nov 2007 09:50:21 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107175021.GI14646@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com> <20071107134255.GE14646@frankl.hpl.hp.com> <20071107170820.GB8358@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107170820.GB8358@kroah.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 09:08:20AM -0800, Greg KH wrote:
> On Wed, Nov 07, 2007 at 05:42:55AM -0800, Stephane Eranian wrote:
> > Greg,
> > 
> > Perfmon sysfs document has been updated following your adivce.
> > you can check out in my perfmon tree  the following commit:
> > 
> > 	e83278f879e52ecee025effe9ad509fd51e4a516
> 
> Where is this git tree located?  On git.kernel.org somewhere?
> 
	http://git.kernel.org/?p=linux/kernel/git/eranian/linux-2.6.git

-- 
-Stephane
