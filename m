Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbZLHAmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbZLHAmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965245AbZLHAmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:42:15 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:36059 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbZLHAmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:42:15 -0500
Date: Mon, 7 Dec 2009 16:42:21 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Zidlicky <rz@linux-m68k.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.32 regression, hard lock
Message-ID: <20091208004221.GA15968@hexapodia.org>
References: <20091206141419.GA6195@linux-m68k.org> <20091207143057.53c6a362.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207143057.53c6a362.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 02:30:57PM -0800, Andrew Morton wrote:
> btw, why does your kernel say "To Be Filled By O.E.M." in the traces? 
> The kernel.org kernel doesn't do that.  Is that kernel patched at all?

That's traditional for DMI_PRODUCT_NAME in dodgy vendor BIOSes.  I
routinely see it on Intel evaluation boards and less frequently on
Taiwanese Brand X boards.

-andy
