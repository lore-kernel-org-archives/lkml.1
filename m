Return-Path: <linux-kernel-owner+w=401wt.eu-S1750766AbXBNGM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750766AbXBNGM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 01:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXBNGM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 01:12:58 -0500
Received: from www17.your-server.de ([213.133.104.17]:1341 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXBNGM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 01:12:57 -0500
Message-ID: <45D2A835.7020606@m3y3r.de>
Date: Wed, 14 Feb 2007 07:12:05 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.9 (X11/20061222)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: undefined symbol 'PS3_PS3AV'
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

with 93bbad8fe13a25dcf7f3bc628a71d1a7642ae61b:

drivers/video/Kconfig:1604:warning: 'select' used by config symbol 
'FB_PS3' refer to undefined symbol 'PS3_PS3AV'
