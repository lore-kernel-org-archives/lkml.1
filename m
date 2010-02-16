Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab0BPVzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:55:14 -0500
Received: from h1466845.stratoserver.net ([85.214.63.213]:52984 "EHLO
	h1466845.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab0BPVzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:55:12 -0500
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2010 16:55:12 EST
Message-ID: <4B7B1229.4030008@d2ux.org>
Date: Tue, 16 Feb 2010 22:46:17 +0100
From: Matthias Petermann <matthias@d2ux.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Synaptics touchpad doesn't click (refers thread from December 2009)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

around mid December 2009 there was a thread with the same topic as in my 
subject on LKML. Initially there were reported click-problems with the 
Synaptics Trackpad-Click like it is present with current HP Envy 13 and 
15 Notebooks.

Dmitry Torokhov stated some very promising patch sets here in this list 
and so far some other persons like Alex Chiang reported success with 
them. Especially I refer to [1].

Can anyone give a short update what happens to this patches? Are they 
fully merged into 2.6.33-rc8? I tried to match the code of the patch 
with it but it looks quite different from my novices eye ;-)


Thanks,
Matthias



[1] http://lkml.org/lkml/2009/12/15/29
