Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYCOVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYCOVb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYCOVa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:30:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:45224 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbYCOVaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=U02YnRhvnm2Zg7Qgp6UvyYQlqVYIhLGlYAMbm8A5OY9hkQ1Lhk3zrYmYCjOjT87QNxgU/SwaltsisTh3ZJMiUbmOeu81WkmQ/1toOpU+znq9FoATvsLl5hM3tcpeSSv/y7qKMbHjWZnOZSOE0pCNhPLFOHhoH8hF+CJb8PYjJ84=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/12] ali14xx: add "vlb_clock=" parameter
Date: Sat, 15 Mar 2008 22:44:11 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain> <20080315123614.6c548306@the-village.bc.nu>
In-Reply-To: <20080315123614.6c548306@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803152244.12050.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008, Alan Cox wrote:
> On Thu, 13 Mar 2008 23:43:52 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Surely this value should be set once per system (ditto for PCI) not
> something you have to set in each specific driver on the box ?

Yeah, I'll re-do the patches.  Thanks for pointing this out.

Bart
