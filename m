Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZGDWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZGDWy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 18:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZGDWyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 18:54:20 -0400
Received: from b-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.35]:56927 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752465AbZGDWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 18:54:20 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jul 2009 18:54:20 EDT
Message-ID: <4A4FDBE9.5010607@pobox.com>
Date: Sun, 05 Jul 2009 07:47:05 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: skuribay@pobox.com, trivial@kernel.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Trivial: Fix filenames in their headers for the EMMA
 Mark-eins.
References: <1246746621-10320-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1246746621-10320-1-git-send-email-cascardo@holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 9F918942-68EC-11DE-8A55-DA7A2FBFAAF1-47602734!b-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thadeu Lima de Souza Cascardo wrote:
> After some renaming, these filenames were not updated to reflect their
> new locations.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Thanks, I'll be more careful hereafter.

Acked-by: Shinya Kuribayashi <skuribay@pobox.com>
