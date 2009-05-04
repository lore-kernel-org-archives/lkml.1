Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZEDH6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZEDH6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZEDH6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:58:23 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61360 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZEDH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:58:22 -0400
Message-ID: <49FE9FED.5070909@nokia.com>
Date: Mon, 04 May 2009 10:57:33 +0300
From: Roger Quadros <ext-roger.quadros@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: ext Marcel Holtmann <marcel@holtmann.org>
CC: Marc Pignat <Marc.Pignat@hevs.ch>, justinmattock@gmail.com,
       hidave.darkstar@gmail.com, jkosina@suse.cz,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
References: <49FDCC85020000BF000290ED@mailgw2.hevs.ch> <1241381821.2785.2.camel@localhost.localdomain>
In-Reply-To: <1241381821.2785.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2009 07:58:09.0881 (UTC) FILETIME=[10F6EC90:01C9CC8E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Marcel Holtmann wrote:
> Hi Marc,
> 
> you really need to fix your mailer. You keep breaking the threading all
> the time and that is clearly your fault.
> 
>>> thanks for testing.
>>> Marc, Roger, can you test this and confirm that it works for you and
>>> doesn't have any other side effects. Then I prepare it work upstream
>>> inclusion.
>> Tested and working!
> 
> great. So I queue this up for 2.6.30 inclusion.
> 
>> Exercise left for 2.6.31: use the system wide wq ;)
> 
> Actually no, the private workqueue is used on purpose. No need to bother
> keventd for a regular task.
> 
> Regards
> 
> Marcel
> 
> 

Hi Marcel,

Yes it works for me too. Thanks.

regards,
-roger
