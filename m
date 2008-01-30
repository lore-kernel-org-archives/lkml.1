Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYA3Ih7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYA3Ih7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYA3Ihu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:37:50 -0500
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:46225 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYA3Ihu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:37:50 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Force enable HPET on (some?) ICH9 boards
Date: Wed, 30 Jan 2008 08:36:27 +0000
User-Agent: KMail/1.9.7
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <1201444379-4223-1-git-send-email-alistair@devzero.co.uk> <924EFEDD5F540B4284297C4DC59F3DEE6CD87A@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE6CD87A@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801300836.27647.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 01:12:33 Pallipadi, Venkatesh wrote:
> Patch looks good.
> If BIOS does not report HPET on more of such systems we may have to add
> other chipsets in ICH9 family (ICH9_8, ...) as well.
>
> Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Hi Ingo,

Are you going to pick this patch up via the x86 tree, or shall I forward it to 
Andrew or trivial@?

Do you want me to re-send with Venki's ack?

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
