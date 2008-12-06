Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYLFOiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYLFOiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbYLFOhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:37:53 -0500
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2595 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbYLFOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:37:52 -0500
Message-ID: <493A8E3E.6080603@xs4all.nl>
Date: Sat, 06 Dec 2008 15:37:50 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ITE: Found unknown chip with ID 0x8720
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just installed a Gigabyte MA770-DS3 board: 
http://www.gigabyte.com.tw/Products/Motherboard/Products_Spec.aspx?ProductID=2722

It has an iTE IT8718 chip according to this url.

But:
sensors-detect says:
Trying family `ITE'...                                      Yes
Found unknown chip with ID 0x8720

And:
modprobe it87 says no such device although 8718F is supported.

Is this a known issue?
Anybody working on it?
How to fix?
Need more info?
Can I help?
Etc?

Kind regards,
Udo
