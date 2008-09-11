Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYIKTOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYIKTOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYIKTOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:14:23 -0400
Received: from scing.com ([217.160.110.58]:58946 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbYIKTOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:14:22 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Matthew Bodkin <matthew.bodkin@innovationone.ca>
Subject: Re: [PATCH 07/18] lirc driver for the CommandIR USB Transceiver
Date: Thu, 11 Sep 2008 21:14:08 +0200
User-Agent: KMail/1.9.9
Cc: Christoph Bartelmus <lirc@bartelmus.de>, corbet@lwn.net,
       jwilson@redhat.com, linux-kernel@vger.kernel.org
References: <AlfDeGfojFB@christoph> <1221159005.13683.34.camel@minimatt>
In-Reply-To: <1221159005.13683.34.camel@minimatt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809112114.09023.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 September 2008 20:50:05 Matthew Bodkin wrote:
>
> True, I added a 'commandir' userspace driver a couple months ago that
> replaces the kernel 'lirc_cmdir' driver.
>
> However the userspace driver remains unreleased in CVS so until there
> is a new LIRC release, I think the include the old kernel driver will
> have to be included.

It doesn't make sense to spend considerible effort cleaning the driver 
up for kernel inclusion if a user space driver exist in licr cvs.

Janne
