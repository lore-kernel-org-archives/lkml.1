Return-Path: <linux-kernel-owner+w=401wt.eu-S966927AbXEGVCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966927AbXEGVCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966639AbXEGVC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:02:27 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52164 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966631AbXEGVC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:02:26 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Kconfig warnings on latest GIT
Date: Tue, 8 May 2007 00:04:14 +0300
User-Agent: KMail/1.9.6
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705080004.14570.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following Kconfig warnings shows up with latest GIT :

drivers/net/Kconfig:2279:warning: 'select' used by config symbol 'UCC_GETH' 
refers to undefined symbol 'UCC_FAST'

drivers/input/keyboard/Kconfig:170:warning: 'select' used by config 
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

drivers/input/mouse/Kconfig:161:warning: 'select' used by config 
symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

Regards,
ismail

-- 
Le mieux est l'ennemi du bien.
