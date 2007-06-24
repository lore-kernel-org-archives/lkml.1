Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXFXRUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXFXRUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXFXRU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:20:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:51643 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXFXRU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:20:27 -0400
Message-ID: <467EA7C1.4080006@rossove.com>
Date: Sun, 24 Jun 2007 12:20:01 -0500
From: David Jones <djones@rossove.com>
Reply-To: djones@rossove.com
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org
Subject: Scaling Max IP address limitation 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am trying to add multiple IP addresses ( v6 ) to my FC7 box on eth0. 
But I am hitting a max limit of 4000 IP address . Seems like there is a 
limiting variable in linux kernel (which one? ) that prevents from 
adding more IP addresses than 4096. What do I need to change in Linux 
kernel  ( and then recompile ) to be able to add more IP addresses than 
4K addresses per system? ..
Thanks,
-d
