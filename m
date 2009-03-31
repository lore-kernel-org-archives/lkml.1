Return-Path: <linux-kernel-owner+w=401wt.eu-S1762687AbZCaWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687AbZCaWgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbZCaWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:36:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37049 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbZCaWgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:36:02 -0400
Date: Tue, 31 Mar 2009 23:35:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Mattia Dongili <malattia@linux.it>, Len Brown <len.brown@intel.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sony-laptop should depend on RFKILL
Message-ID: <20090331223555.GA31066@srcf.ucam.org>
References: <20090331223407.GA10676@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331223407.GA10676@orion>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 02:34:07AM +0400, Alexander Beregalov wrote:
> Fixes this build error when RFKILL is not set:
> 
> drivers/platform/x86/sony-laptop.c:1050: undefined reference to `rfkill_unregister'
> and so on..
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
