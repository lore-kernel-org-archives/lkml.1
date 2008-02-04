Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYBDQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYBDQLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYBDQLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:11:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:51536 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYBDQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:11:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=B9rbY+iP4pTO6LpXDNRXCsPr6yVHYPtQFd3tE4E9zlGRg3zFLlcJJpRUD3ub1sk5XVXLNR+hRP61bVrY9VLHXkON/MYJDtHL8wnjjNqXOu9cB2ffbsLN/ga4dVUZfU8Nf+wxD5iQHLE5r6ixia4Zn4KdlMiX2+Yw8OfL2K10uWY=
Date: Mon, 4 Feb 2008 17:11:00 +0100
To: linux-pcmcia@lists.infradead.org,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Where to send new pcmcia driver?
Message-Id: <20080204171100.e9aff4a5.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
Im almost finished with my pcmcia driver for the h64461 chipset, it works fine just need to clean it up.

Now looking at the MAINTAINER list it doesn't reference anyone special as the maintainer for pcmcia subsystem.
So in short where should I send the patch?

Also, I've tried on numerous occasions to seek help on pcmcia list and besides some helpful replies from Peter Stuge, it's been
silent. Perhaps linux-pcmcia mailinglist would be better off getting merged into linux-main list?

Best wishes
Kristoffer
