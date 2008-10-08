Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYJHUwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYJHUwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYJHUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:52:32 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45633 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbYJHUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:52:31 -0400
Date: Wed, 08 Oct 2008 16:50:57 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2 2/2] eeepc-laptop: Use standard interfaces
In-reply-to: <20080819111320.GA19223@srcf.ucam.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, corentincj@iksaif.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0810081649030.3041@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080804170833.GA9513@srcf.ucam.org>
 <20080806092352.GA17801@srcf.ucam.org> <20080806092523.GB17801@srcf.ucam.org>
 <20080819025815.b5ec1a4c.akpm@linux-foundation.org>
 <20080819111320.GA19223@srcf.ucam.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Matthew Garrett wrote:

> eeepc-laptop currently only sends key events via ACPI and has 
> non-standard rfkill control. Add an input device and use the rfkill 
> infrastructure.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

applied to acpi-test.
Corentin Chary, you're the driver maintainer, do you Ack?

thanks,
-Len

