Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZAWSFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZAWSFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbZAWSFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:05:07 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:54255 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbZAWSFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:05:06 -0500
Message-ID: <497A06CE.9040901@walrond.org>
Date: Fri, 23 Jan 2009 18:05:02 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
References: <497A0164.90409@walrond.org> <497A034F.6060303@caviumnetworks.com>
In-Reply-To: <497A034F.6060303@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> You do have to have your kernel configured properly for a serial 
> console for it to work right.
>
Sorry to be blunt, but I don't think you read my message very carefully! 
I am reporting kernel bug(s) in the serial subsystem, not amateur 
configuration problems. I know what I'm about, but on a random selection 
of 3 servers with identical kernels/software, the serial subsystem works 
fully on none of them. All boot just fine to the normal console.

Andrew Walrond

