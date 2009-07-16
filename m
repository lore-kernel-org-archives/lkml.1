Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZGPJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZGPJcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZGPJcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:32:18 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:53309 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbZGPJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:32:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding:subject
         :mime-version:date:x-mailer;
        b=UgfKYR03Bfiw6v3hjv1Zm8def/yEqkO8ZqZ+LKAyiBGXiHdua+vkXkxHQV4zp5mg0C
         dPFhX2TSuTUv7rqMffcIxyWQ6wqUOZBMlMBz8kCPpKWMaYpDFB5Ax4WnGGdKAS5hV3TZ
         Ds+Q7/D+lcktfnPeZZBmIXAC9orT5qK3IGoaE=
Message-Id: <3B5FFAA5-F608-4F43-B510-BF70BC5DC225@gmail.com>
From: Patrick Rittiner <rittiner@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Subject: interface index
Mime-Version: 1.0 (Apple Message framework v935.3)
Date: Thu, 16 Jul 2009 11:32:10 +0200
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

can someone tell me how I can get the interface index of a socket  
connection in kernel space? I mean ow can I use this call in kernel  
space:
	ioctl(sock, SIOCGIFFLAGS, &ifInfo)
I need it to bind the socket to a ethernet interface.
thanks a lot
