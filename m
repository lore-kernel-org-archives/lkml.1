Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYLHGOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYLHGOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYLHGOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:14:11 -0500
Received: from cuda1.bluetone.cz ([212.158.128.5]:36798 "EHLO mail.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYLHGOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:14:10 -0500
Message-ID: <493CBBB4.4020601@slax.org>
Date: Mon, 08 Dec 2008 07:16:20 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: reboot during kernel panic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

When kernel goes to panic, it does not appear to accept Ctrl+Alt+Del to reboot the machine. Is there any way to reboot it then? Lets assume I can't send any sysrq keys.

If that is not even possible to reboot it since it is in panic, what is the reason for that?

Thank you

Tomas M
