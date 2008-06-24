Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYFXHAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYFXHAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYFXHAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:00:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29538 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYFXHAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:00:07 -0400
Date: Tue, 24 Jun 2008 08:59:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Zhang Rui <rui.zhang@intel.com>,
       linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2
  userspace
Message-ID: <20080624085940.3ee3bf77@hyperion.delvare>
In-Reply-To: <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no>
	<fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no>
	<48605935.5070407@shaw.ca>
	<alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 23 Jun 2008 20:07:15 -0700 (PDT), Linus Torvalds wrote:
> On Mon, 23 Jun 2008, Robert Hancock wrote:
> > Mark M. Hoffman wrote:
> > > 2) This patch is broken.
> > 
> > You didn't indicate what was wrong with the patch.
> 
> Yes. Leaving everybody wondering whether it's just an opinionated 
> expression of the former problem, or whether there is a real and 
> understandable reason why it was NACK'ed.

I guess Mark assumed that everybody had read the discussion thread Rene
referenced, where I explained why his patch was broken:

http://lkml.org/lkml/2008/6/23/175

-- 
Jean Delvare
