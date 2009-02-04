Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZBDLUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZBDLUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZBDLUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:20:05 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:45442 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZBDLUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:20:04 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [stable]  A patch in 2.6.27.9 caused device names to change
Date: Wed, 4 Feb 2009 12:20:56 +0100
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
References: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com> <20090203000529.GC9467@kroah.com> <1233672611.11344.6.camel@localhost.localdomain>
In-Reply-To: <1233672611.11344.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902041220.58180.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 03 February 2009 15:50:11 schrieb Dan Williams:
> Furthermore, up until this point, I have not seen mobile broadband
> adapters (that aren't cellphones connected via USB) that *are* CDC-ACM
> compliant.  Everything previously has advertised proprietary interfaces,
> some of which are serial ports and some of which are not.
> 
> Most mobile broadband cards *do* have more than one TTY, the others are
> used for additional control ports or proprietary access for stuff like
> GPS and flashing the firmware.

Exactly for this reason, the cdc-wdm driver has been added to the kernel.

	Regards
		Oliver

