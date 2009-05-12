Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbZELI1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbZELI1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZELI1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:27:38 -0400
Received: from torres.zugschlus.de ([85.214.68.41]:49555 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZELI1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:27:37 -0400
X-Greylist: delayed 2701 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2009 04:27:37 EDT
Date: Tue, 12 May 2009 09:42:35 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: tua6100_sleep: i2c error when trying to tune saa7146 based  DVB
	card
Message-ID: <20090512074235.GA22900@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, my entertainment PC has begun to refuse tuning to my
favorite stations, logging "tua6100_sleep: i2c error" when I try to do
so. Kaffeine says "can't tune DVB".

Other stations work just fine.

The box has a saa7146 equipped budget DVB-S card which used to work
fine previously. I have first seen this behavior in kernel 2.6.29, and
still see it in 2.6.29.3.

If you need any more data, please ask and I'll try to deliver it.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
