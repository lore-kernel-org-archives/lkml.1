Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZKIJZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZKIJZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZKIJZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:25:10 -0500
Received: from mail-px0-f195.google.com ([209.85.216.195]:45887 "EHLO
	mail-px0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZKIJZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:25:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=Zq0knxcEh8BhTzv9+fNZn0wVk6tYgMSWjewDy9T+quKfrQDBs/ZbWr4sQXrLjq7szi
         LLevae9CbBLf5NCbzwk1140wQWoX8v2z9AD0WAghHKOBpeTZvm0GTZUDUXbSj1T2MFPr
         lzL4C2Slgk/IV6i4fB5kkUeT8rY2OBgjUzOaY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/2] pcf50633 - a couple of fixes
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Nov 2009 01:25:10 -0800
Message-ID: <20091109092447.29634.79364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Please consider applying these 2 patches to your tree. They add
some error handling to PCF50633 core and switch it to using the
stabdard threaded IRQ instead of the custom solution.

I don't have the hardware so patches are compile-tested only.

Thanks.

-- 
Dmitry
