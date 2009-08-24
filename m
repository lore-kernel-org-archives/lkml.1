Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZHXRzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZHXRzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZHXRzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:55:53 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54593 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZHXRzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=ZlYLHN6p1mlfEb2o27DxAhZ/jsx0EUXCFCcuAxRULc/CzAoXNd1ydn1qqBZuWcp/yC
         rIIsu8viACTSK5gEDddTGBGnbfqcpGsu3fJ344I4no7Hyw4VghB4cdOWRjUqE0ikPcp1
         fbOt9TFdIvlGmTC7ACJE2H5L1rTnzUuK1xGM8=
Message-Id: <20090824175335.186713800@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 24 Aug 2009 21:53:35 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [rfc -tip 0/4] x86 apic,ioapic fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a series of trivial patches together
with a few not that insignificant.

Please review.

Thanks, Cyrill
