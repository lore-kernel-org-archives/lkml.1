Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbYDLFPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbYDLFPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYDLFP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:15:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39968 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYDLFP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:15:28 -0400
Date: Fri, 11 Apr 2008 21:29:18 -0700
From: Greg KH <greg@kroah.com>
To: "Rachmel, Nir (Nir)" <rachmel@avaya.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Oops on hot insertion of USB
Message-ID: <20080412042918.GA13154@kroah.com>
References: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 03:06:05PM +0200, Rachmel, Nir (Nir) wrote:
> Hi,
> 
> 	I am running linux kernel version 2.6.14.7, and have a problem
> when
> 	inserting / removing a disk-on-key device from my system: I get
> a
> 	"kernel oops". Using some debugging tools I managed to trace the
> 	problem down to an event of "double free" that occurs within the
> hot
> 	insertion module.
> 	
> 	googling didn't help much. Is this a known issue which is
> resolved in
> 	later kernel versions?

Yes it is, please upgrade :)

thanks,

greg k-h
