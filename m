Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284Ab0AWWaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab0AWWaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 17:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095Ab0AWWaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 17:30:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:58442 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0AWWaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 17:30:14 -0500
Date: Sat, 23 Jan 2010 14:30:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
       adkulkar@umail.iu.edu
Subject: Re: NFS_FSCACHE still depends on EXPERIMENTAL?
Message-ID: <20100123143040.49f47e0d@infradead.org>
In-Reply-To: <alpine.DEB.2.01.1001231314480.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001231314480.3483@bogon.housecafe.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010 13:35:39 -0800 (PST)
Christian Kujau <lists@nerdbynature.de> wrote:

> Hi,
> 
> there's currently an open Ubuntu bug[0], with the intent to compile 
> NFS_FSCACHE (and possibly AFS_FSCACHE, 9P_FSCACHE) into the standard 
> Ubuntu kernel. However, since *_FSCACHE still depends on
> EXPERIMENTAL, this won't happen.


since the EXPERIMENTAL flag more or less means nothing, the
"it is marked with the flag so we don't do it" is reasoning based on
more or less nothing...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
