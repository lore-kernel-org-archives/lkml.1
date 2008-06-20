Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbYFTOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbYFTOlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYFTOk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:40:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52448 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbYFTOk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:40:59 -0400
Date: Fri, 20 Jun 2008 08:40:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Strange problem with e1000 driver - ping packet loss
In-reply-to: <20080620123054.GH3548@linux.vnet.ibm.com>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       varunc@linux.vnet.ibm.com, jbarnes@virtuousgeek.org, greg@kroah.com
Message-id: <485BC16F.8050409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no>
 <485A9678.5000707@shaw.ca> <20080620123054.GH3548@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> On Thu, Jun 19, 2008 at 11:25:12AM -0600, Robert Hancock wrote:
>> Can you post your dmesg output from bootup with no special options (noacpi, 
>> etc.) enabled?
> 
> Here it is (from RHEL5 kernel, no special boot options):

Looks reasonable to me.. and what does /proc/interrupts show with this 
setup?
