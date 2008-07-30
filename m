Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758951AbYG3HWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYG3HWB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 30 Jul 2008 03:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYG3HVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:21:51 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:13346 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYG3HVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=fQP8Gh73gz6SYhybbHZ3eVWA8bxGsAmtn9MJ9V7BztiWrVVjUCaTqGCLeq39HlL5z8
         w3O/26oO+JUJLXSAc9K0DSBnm1t/7xEtjiQpWSeVYbBJEp15lEA1XQWqesn74rn88PFO
         uKAWbYb3oso9xNIQA62P+1Mnm/nJEApuf+h/A=
Message-ID: <dd18b0c30807300021vc79fe6aj9cac07f0b7e21ca3@mail.gmail.com>
Date: Wed, 30 Jul 2008 00:21:50 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: wireless+ firefox= no address found
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when running wireless with 2.6.27-rc1
I can stream music, but as soon as I load firefox
I have a no address found, under netstat -ntu
I see the radio stream, but nothing when firefox loads.
I have submited a ticket to madwifi, and have reverted the wireless
stuff, but still blank.

-- 
Justin P. Mattock
