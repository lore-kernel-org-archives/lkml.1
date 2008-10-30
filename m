Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYJ3PBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYJ3PBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYJ3PBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:01:30 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:36411 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbYJ3PB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:01:29 -0400
Message-ID: <4909CC40.1010106@nortel.com>
Date: Thu, 30 Oct 2008 09:01:20 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: David Daney <ddaney@caviumnetworks.com>,
       linux-mips <linux-mips@linux-mips.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: Re: [PATCH 00/36] Add Cavium OCTEON processor support (v2).
References: <490655B6.4030406@caviumnetworks.com> <alpine.LFD.1.10.0810291905020.13373@ftp.linux-mips.org>
In-Reply-To: <alpine.LFD.1.10.0810291905020.13373@ftp.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2008 15:01:24.0071 (UTC) FILETIME=[603F4F70:01C93AA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Mon, 27 Oct 2008, David Daney wrote:
> 
> 
>>This patch set introduces preliminary support for Cavium Networks'
>>OCTEON processor family.  More information about these processors may
>>be obtained here:
>>
>>http://www.caviumnetworks.com/OCTEON_MIPS64.html
> 
> 
>  Well, in the context of a technical mailing list there isn't much more 
> information available at the link you've quoted; although I do understand 
> you might not be the most appropriate person to point it to.  Honestly, 
> stating: "The family comprises SOC devices built around MIPS64 cores" 
> would provide about as much (little) information as the web site does. :(

You can register for free at www.cnusers.org and they have a bit more 
information there as well as existing SDKs with full linux source for 
older versions.  However, it looks like the really gory details are 
available only after signing an NDA.

Chris
