Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZLSTV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZLSTV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 14:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZLSTV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 14:21:27 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:43228 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZLSTVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 14:21:25 -0500
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUPIzI/Orkx
X-RZG-CLASS-ID: mo00
Message-ID: <4B2D27B6.3000707@hartkopp.net>
Date: Sat, 19 Dec 2009 20:21:26 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>, johnstul@us.ibm.com
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Also on x86 - was: 2.6.33-rc1: hrtimers and tickless broken on m68knommu.
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i'm currently checking in LKML why my Dell 830 Laptop is not booting at all
with 2.6.33-rc1 - and i found your thread:

http://lkml.org/lkml/2009/12/18/494

I also use a setup with tickless & hrtimers enabled - but on a x86.

Same behaviour as on your m68knommu box: Just nothing to see ...

Regards,
Oliver





