Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYH0WLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYH0WLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYH0WLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:11:45 -0400
Received: from gw.goop.org ([64.81.55.164]:44890 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYH0WLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:11:44 -0400
Message-ID: <48B5D11E.5090209@goop.org>
Date: Wed, 27 Aug 2008 15:11:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: /proc/acpi/ibm/wan stopped appearing
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/acpi/ibm/wan stopped appearing for me at some point recently
(bluetooth is still there).  I guess this has something to do with the
RFKILL changes, but I haven't looked at them in detail.  I guess my
question is: is this expected, and what's the "proper" way to control
the WWAN radio now?

Thanks,
    J
