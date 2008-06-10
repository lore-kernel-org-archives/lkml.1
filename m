Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbYFJHWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbYFJHWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYFJHWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:22:24 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:44991 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYFJHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Q1lEtTkEnBmtVPo3UpqQAHk2EIJxs8jEN+7eeC+/9K4O5QtDC15CdfwTeLm/pzJFbb
         MBjwIBDtJY24JwWvYK5cU4vRiKsWgGt3oHHSVsUdIY8R04HlttvGRSz4sEFrZmOorLTL
         DZacgmgVqaxmdULoimHYAVk5IbigqTzVCJk4A=
Message-ID: <dd18b0c30806100022h15a54f73p7889eb342393a141@mail.gmail.com>
Date: Tue, 10 Jun 2008 07:22:22 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [Bug #10825] appletouch after wakeup
Cc: "Oliver Neukum" <oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending this e-mail as an update: With the patch today, I am not
seeing appletouch give the error that it did,
now for another plus is after messing with xorg.conf the right
horizontal scroll function, and 2 and 3 finger tap work upon wakeup,
I've performed five or so suspends and each one was successful with
the appletouch not complaining like it did, and all functions working.
Thanks again for the patch.
regards;


-- 
Justin P. Mattock
