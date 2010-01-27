Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514Ab0A0Prl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0A0Prl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115Ab0A0Prk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:47:40 -0500
Received: from www84.your-server.de ([213.133.104.84]:58957 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0A0Prj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:47:39 -0500
Subject: Re: [PATCH 0/3 for 2.6.33] Some fixes for kfifo and FHCI
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@suse.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20100127145054.GA24673@suse.de>
References: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
	 <20100127145054.GA24673@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Jan 2010 16:47:39 +0100
Message-ID: <1264607259.8302.0.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 27.01.2010, 06:50 -0800 schrieb Greg KH:
> On Wed, Jan 27, 2010 at 05:08:09PM +0300, Anton Vorontsov wrote:
> > Hi all,
> > 
> > FHCI no longer builds after kfifo rework, this patch set is
> > used to fix the issues.
> 
> If there are no objections to these, I'll queue these up and send them
> through my tree as they affect the FHCI driver.
> 

Looks good for me, so
Acked-by: Stefani Seibold <stefani@seibold.net>



