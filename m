Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0CJMhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:37:08 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:54206 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0CJMhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:37:04 -0500
Message-ID: <4B978C28.7080100@inf.tu-dresden.de>
Date: Wed, 10 Mar 2010 13:10:16 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100217 Shredder/3.0.3pre
MIME-Version: 1.0
To: Evan McClain <evan.mcclain@gatech.edu>
CC: rpurdie@rpsys.net, akpm@linux-foundation.org, mjg@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: mbp_nvidia_bl - add five more MacBook variants
References: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu>
In-Reply-To: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about finally adding all machines to the list?
As far as I know, we have:

* already present in Linus'/Richard Purdie's tree:
     Intel chipset:
         MacBookAir 1,1
         MacBookPro 3,1
         MacBookPro 3,2
         MacBookPro 4,1

     Nvidia chipset:
         MacBook 5,1
         MacBook 5,2
         MacBookAir 2,1
         MacBookPro 5,1
         MacBookPro 5,2
         MacBookPro 5,3
         MacBookPro 5,4
         MacBookPro 5,5

* recently proposed to add by Evan McClain:
     Intel chipset:
         MacBook 1,1
         MacBook 2,1
         MacBook 3,1
         MacBook 4,1
         MacBook 4,2

* still missing:
     Intel chipset:
         MacBookPro 1,1
         MacBookPro 1,2
         MacBookPro 2,1
         MacBookPro 2,2

     Nvidia chipset:
         MacBook 6,1

ciao,
Mario
