Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbXKAUjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbXKAUjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXKAUjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:39:44 -0400
Received: from smtpauth05.prod.mesa1.secureserver.net ([64.202.165.99]:54667
	"HELO smtpauth05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753419AbXKAUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:39:43 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 16:39:43 EDT
Message-ID: <472A37EA.80209@seclark.us>
Date: Thu, 01 Nov 2007 16:32:42 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, andreas@kempe.biz
Subject: asus-laptop module
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

When the asus-laptop module is loaded it automatically turns on my 
wireless led
light irregardless of the whether or not the my wireless is up or not. I 
had previously
been using the out of kernel asus-laptop module, which no longer 
compiles because of
missing some structure definition, Andreas Kempe had added a module 
parameter to
the out of tree version that let the module be loaded with the led off 
by passing
wled=0 as a parameter.

Can this be added to the in kernel version? Or the default for the 
wireless led be off
when loading the module?

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



