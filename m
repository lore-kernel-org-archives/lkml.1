Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbXGRKD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbXGRKD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXGRKDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:03:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXGRKDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:03:49 -0400
Message-ID: <469DE555.10507@anagramm.de>
Date: Wed, 18 Jul 2007 12:03:01 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org,
       Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 03/33] powerpc: Refuse to build 64-bit with GCC-4.2.0
 and CONFIG_MODULES
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org>
In-Reply-To: <1184681343138-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18QS5ocH1pC0/ERUpufEZpBSH5e3nRTPUgpKyR
 xkMCKlksUNSyTYSlZ2RK53E83oFFM2gGQ74Hok8pztPvOyCRkT
 qZ4djzgNtLhF8rdae03dA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg schrieb:
> From: Segher Boessenkool <segher@kernel.crashing.org>
> 
> ...since this won't work (compiler bug, see <http://gcc.gnu.org/PR31490>).

The bug report says IA64 is broken, too. Please verify and extend the
patch if possible...

gcc-4.2.1 will be released soon.

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
