Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZIJQPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZIJQPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZIJQPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:15:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39685 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZIJQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:15:22 -0400
Date: Thu, 10 Sep 2009 17:15:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 5/6] thermal: Only set passive_delay for forced passive
	cooling
Message-ID: <20090910161516.GA7195@srcf.ucam.org>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251303445-25317-6-git-send-email-elendil@planet.nl> <20090826162537.GC15868@srcf.ucam.org> <200909101807.13874.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909101807.13874.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 06:07:12PM +0200, Frans Pop wrote:

> Have you had a chance to check this?

I think this was just an artifact of me modifying the existing logic 
rather than it being meaningful, so as long as this works for you:

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
