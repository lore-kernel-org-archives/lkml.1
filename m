Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYIQRB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYIQRB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYIQQzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:55:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:7746 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbYIQQzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=VIzXyowg7zMcglpaVTITJeOapyxatYtqRKa88BX4uYpex48zLQRDB2CsbCaSdwNeNn
         TZKwUa0pLWRsaMpfQgAuvUAiGtBtZ65bUAu/ktY5/zkvweqkko/SMIdmcX//0Gf6EQd9
         w+bwNUi3oLnhaRUPKovYGSxlE8f5zldcdyBSA=
Message-ID: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
Date: Wed, 17 Sep 2008 22:25:35 +0530
From: "Singaravelan Nallasellan" <singaravelann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: New IOCTLs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to send device control messages to the driver. I am planning to
use the IOCTLs. But I came to know that Linux community does not
accept any new IOCTLs anymore.
Can somebody provide the reason behind the decision? Are there any
better approach to implement the device control interface other than
sysfs interface. I have some issues in using the sysfs interface.
Thanks in advance.
