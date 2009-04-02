Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbZDBWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbZDBWGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbZDBWGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:06:32 -0400
Received: from smtp3.epfl.ch ([128.178.224.226]:37645 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752363AbZDBWGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:06:31 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 18:06:31 EDT
Message-ID: <49D53551.8070301@epfl.ch>
Date: Thu, 02 Apr 2009 23:59:45 +0200
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Equivalent to dynamic_printk cmd line option with dynamic_debug ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on support of an embedded system so I usually post and read 
the linux-arm mailing-list.

I used to find the dynamic_printk cmd line option very helpful to debug 
the "later" startup of my kernel. However, with dynamic_printk having 
been merged with dynamic_debug during the current merge window, I cannot 
do it anymore (or at least I haven't found how to in 
Documentation/dynamic-debug-howto.txt).

Is there a way to achieve it with the actual system? If not, I would say 
this would be a nice feature to add.

Thanks

Valentin
