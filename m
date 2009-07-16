Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbZGPOIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbZGPOIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbZGPOIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:08:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57217 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbZGPOIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:08:10 -0400
Date: Thu, 16 Jul 2009 17:07:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: anthony@codemonkey.ws, avi@redhat.com, kvm@vger.kernel.org,
       chrisw@redhat.com, hjk@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090716140709.GA16321@redhat.com>
References: <20090715201340.GA12279@redhat.com> <20090715220829.GB31962@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715220829.GB31962@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 03:08:29PM -0700, Greg KH wrote:
> How about moving that documentation into a place that people will notice
> it, like the rest of the UIO documentation?

Greg,

would it make more sense to add this to
Documentation/DocBook/uio-howto.xml, or to create
Documentation/uio_pci_generic.txt ?
