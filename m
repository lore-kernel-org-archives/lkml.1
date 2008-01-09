Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYAINz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYAINz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYAINzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:55:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:12920 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYAINzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=r2jn4EdL4pbNExKKN7M+OXdf+QLhBxlEmW84bnIa0NRibodthpR/aekNe2petnGhgFqlJXQoModVuV8cxxzcDw1rGIMY7kNIPlVlOdSidayYnv2V2AwzayvG1GgDx9w8KPjl4MIjgTRuta4xTb/U85WveeDXf/t05oUTSb/t4zc=
Message-ID: <4784D2E1.5020701@gmail.com>
Date: Wed, 09 Jan 2008 16:57:53 +0300
From: Konstantin Kalin <konstantin.kalin@gmail.com>
Reply-To: konstantin.kalin@gmail.com
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Strange freeze on 2.6.21
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to ask your help with strange behavior of kernel 2.6.21-7. 
Sometimes it becomes to inoperable state and the system time stops. Also 
I couldn't ping the system that moment. But if I try to use keyboard the 
system will wake up and begin working. In other words all programs are 
continuing work normally - there are only one thing - the system time is 
slow on delay between moments when the system had stopped and I used the 
keyboard. It happens on several computers but they have similar hardware 
(AMD64 X2, ASUS M2NPV-VM).

I need an advice how I may collect information about the moment when the 
system stops. /var/log/messages doesn't contain any useful information 
near the time of stopping. There are nothing strange.

Thank you,
Kostya.
