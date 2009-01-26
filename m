Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZAZOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZAZOiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZAZOiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:38:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51208 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZAZOiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:38:13 -0500
Date: Mon, 26 Jan 2009 14:38:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] hp-wmi: set initial docking state
Message-ID: <20090126143808.GA15597@srcf.ucam.org>
References: <200901261536.02809.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901261536.02809.elendil@planet.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 03:36:01PM +0100, Frans Pop wrote:
> If the initial state is not set when the input device is set up, the
> first docking event after the module is loaded will be lost.
>     
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
