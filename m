Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYLJJyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYLJJyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYLJJyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:54:36 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:53294 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYLJJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:54:36 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: [PATCH] usb: make printk messges more searchable
Date: Wed, 10 Dec 2008 10:56:14 +0100
User-Agent: KMail/1.9.9
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org
References: <20081210072921.GA18142@localhost> <200812101042.17530.laurent.pinchart@skynet.be>
In-Reply-To: <200812101042.17530.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101056.15457.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. Dezember 2008 10:42:17 schrieb Laurent Pinchart:
> Hi Wu,
> 
> On Wednesday 10 December 2008, Wu Fengguang wrote:
> > Make USB printk messages long and straightforward.  One of these
> > decorated USB error messages cost me some smart efforts to locate.
> 
> That would make the code break the 80 columns limit.
> 
> From "Documentation/CodingStyle":
> 
> "The limit on the length of lines is 80 columns and this is a strongly
> preferred limit."

Too rigid an application is bad. The kernel must be greppable.

	Regards
		Oliver
