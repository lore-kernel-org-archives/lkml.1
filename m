Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbYLXT5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbYLXT5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 14:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYLXT47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 14:56:59 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:36793 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750912AbYLXT46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 14:56:58 -0500
Message-ID: <495293BC.9000104@pardus.org.tr>
Date: Wed, 24 Dec 2008 21:55:40 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: hid-dummy in 2.6.28_rc8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Whenever I boot into 2.6.28_rc8, the following line is printed(probably 
by modprobe triggered by udev) to the console:

FATAL: Error inserting hid_dummy 
(/lib/modules/2.6.28_rc8-114/kernel/drivers/hid/hid-dummy.ko): 
Input/output error

No signs of error on dmesg output? Any ideas that can help or debug the 
issue?

Regards,

-- 

Ozan Çağlayan
<ozan_at_pardus.org.tr>

