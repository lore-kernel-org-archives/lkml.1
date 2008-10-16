Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYJPRnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYJPRnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYJPRni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:43:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:21761 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYJPRnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=NnIUlq5gYUEPLChAxNzFbZGckj3rIuvVcFe76sJb4ZHyh4wwbAxQ7Rx+YCbJ9o57uM
         cAhfnV8olROp/SWbRGVyLDyqA6t/GgvyozJeDLXNGxpINDa3krbdDnqg6CtyqOsPnSw2
         L6GMWOvp3Ne9HUAr5AfSG0XPW1nPMnTd9274M=
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 0/9] Blacfin Serial Driver updates for 2.6.28-rc1 (v2)
Date: Fri, 17 Oct 2008 01:43:58 +0800
Message-Id: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan,

I split out the barrier change required by Blackfin SMP like patch and
also added some new bug fixing from Sonic.

Thanks
-Bryan
