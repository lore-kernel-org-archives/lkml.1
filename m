Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZIIWmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZIIWmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZIIWmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:42:16 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57149 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbZIIWmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:42:16 -0400
Date: Wed, 9 Sep 2009 18:42:06 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Michal Simek <monstr@monstr.eu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: Cleanup linker script using new linker script
 macros.
In-Reply-To: <4AA7DFF7.6010001@monstr.eu>
Message-ID: <alpine.DEB.1.10.0909091307590.15693@dr-wily.mit.edu>
References: <1252293010-13038-1-git-send-email-tabbott@ksplice.com> <4AA7DFF7.6010001@monstr.eu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Michal Simek wrote:

> If you want to add this patch through microblaze tree, please let me know.

I think it would be best to add it via the microblaze tree (in general I 
have been adding these cleanup patches via the architecture trees when 
possible).

	-Tim Abbott
