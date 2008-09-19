Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYISN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYISN3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYISN3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:29:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54066 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYISN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:29:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48D3A90E.4020506@s5r6.in-berlin.de>
Date: Fri, 19 Sep 2008 15:28:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement ARRAY_SIZE().
References: <20080918132447.516309749@fluff.org.uk>	 <20080918150624.GA3421@x200.localdomain>	 <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com>	 <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com>
In-Reply-To: <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:
> On Fri, Sep 19, 2008 at 2:54 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> well, it seems it's not that good to use ARRAY_AND_SIZE at all.
>> Yes it's short but quite frankly - hiding number of args is not
>> that good.
...
> I have to admit
> that a macro expanding to something like an argument list instead
> of a single variable or something  is not a good idea. But, we are
> using C,
...

Exactly, we generally program in C --- not in cpp.
-- 
Stefan Richter
-=====-==--- =--= =--==
http://arcgraph.de/sr/
