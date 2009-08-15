Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZHOVHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZHOVHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 17:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZHOVHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 17:07:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53141 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZHOVHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 17:07:21 -0400
Message-ID: <4A872386.4080908@pobox.com>
Date: Sat, 15 Aug 2009 17:07:18 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Export AHCI capabilities
References: <1247854427-3315-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1247854427-3315-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> AHCI exports various capability bits that may be of interest to userspace
> such as whether the BIOS claims a port is hotpluggable or eSATA. Providing
> these via sysfs along with the version of the AHCI spec implemented by
> the host allows userspace to make policy decisions for things like ALPM.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

I would prefer a better-yet-more-general interface, but I don't think 
one will appear anytime soon, so...

applied



