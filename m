Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbZKYRYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbZKYRYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759297AbZKYRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:24:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53900 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759235AbZKYRY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:24:29 -0500
Date: Wed, 25 Nov 2009 17:26:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/86] pata_cmd640: document known issues
Message-ID: <20091125172633.7a15711b@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170436.5446.83994.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170436.5446.83994.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:04:36 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_cmd640: document known issues
> 
> Document known issues with the driver to aid distribution makers,
> users and developers in making informed decisions instead of wasting
> their time needlessly.

Umm. its a) under CONFIG_PCI, and b) says CMD640 PCI IDE...
