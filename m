Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYLBRDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYLBRDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYLBRDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:03:25 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:2845 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYLBRDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:03:24 -0500
Date: Tue, 2 Dec 2008 11:03:22 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dcdbas: Export functionality for use in other drivers
Message-ID: <20081202170322.GC9524@auslistsprd01.us.dell.com>
References: <20081127163357.GA22846@srcf.ucam.org> <20081202035237.GC15966@kroah.com> <20081202040319.GB17015@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202040319.GB17015@srcf.ucam.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 04:03:19AM +0000, Matthew Garrett wrote:
> dcdbas: Export functionality for use in other drivers
>     
> The dcdbas code allows calls to be made into the firmware on Dell systems.
> Exporting this to other drivers allows them to implement Dell-specific
> functionality in a safe way.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Looks good, thanks for doing this.
-Matt
-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
