Return-Path: <linux-kernel-owner+w=401wt.eu-S935759AbZDIQ6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759AbZDIQ6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759165AbZDIQ5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:57:45 -0400
Received: from rtr.ca ([76.10.145.34]:48965 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZDIQ5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:57:44 -0400
Message-ID: <49DE2905.3030102@rtr.ca>
Date: Thu, 09 Apr 2009 12:57:41 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca> <49DDF744.1090209@garzik.org>
In-Reply-To: <49DDF744.1090209@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> a single utility should be used to configure a SATA+SAS 
> controller port.  Requiring use of hdparm when the port is in SATA mode, 
> and sg_* when the port is in SAS mode, is a bit annoying.
..

That's why hdparm uses sg_* whenever possible already.

-ml
