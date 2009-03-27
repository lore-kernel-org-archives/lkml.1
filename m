Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZC0R00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZC0R00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZC0R0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:26:18 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:43270 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZC0R0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=iGJ8ShEutZqW+Uu//BJNXjIYnY68tQO/MtjGDLRMLm0KX06E0oo6vq3IqRhuyrFxlG
         XV6hjrhRTw4Y5IV+7nJqHLRNYuUAldQHvNycMJfejgbnXaAjl6o94wb2V484Y3OIIdoE
         S1uO9uL9SkQcI8E29XsdZEScaKbUIRswIY3PU=
From: Eric Lacombe <goretux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [x86_64] /dev/kmem
Date: Fri, 27 Mar 2009 18:26:07 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.28-11-generic; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271826.07781.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to read on /dev/kmem on an x86_64 system (2.6.26.5) and saw that it 
did not work.
I read that article from Jonathan Corbet:

http://lwn.net/Articles/138063/

And I didn't find the definition of FMODE_ANY_OFFSET in the kernel sources.

Could anyone explain how to read on /dev/kmem on an x86_64 system?

Thanks in advance,

	Eric Lacombe

