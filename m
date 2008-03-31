Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYCaMCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYCaMCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYCaMB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:01:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:15303 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYCaMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mxf3gQ40xkgnoCt1TjwZRxOWADqJEMn7dGCqjQ3OL8/w7oP+6dPf3Xq/Q5L32XW3dczuFMzPR7+se51KK5UDf1d/79E6OzM5Q9rbnRbPn46BdLXXY36Us6ylRxM/3IrRjfJx4S7o59EtXUDSIGACLDugO2Ti/76NZ3itQjfe/ts=
Message-ID: <47F0D201.6030102@gmail.com>
Date: Mon, 31 Mar 2008 13:58:57 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Peter Teoh <htmldeveloper@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
Subject: Re: RFC:   Writing Solaris Device Drivers in Java
References: <47F0491F.4050804@gmail.com> <1206959293.8514.636.camel@twins>
In-Reply-To: <1206959293.8514.636.camel@twins>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra pisze:
> On Mon, 2008-03-31 at 10:14 +0800, Peter Teoh wrote:
>> Interesting read:
>>
>> http://research.sun.com/techrep/2006/smli_tr-2006-156.pdf
>>
>> Personal comments:
>>
>> Since KVM and Xen/OpenVZ etc other virtual machines are beginning to pop 
>> up - I don't see why it inhibits (in spite of the many initial 
>> difficulties as mentioned in the paper) the growth of using Java for 
>> device drivers development.   Contrast it against udev - esp in terms of 
>> usability/supportability/extensibility etc.   udev is a Linux thing, 
>> whereas Java is at industry level.   If everyone write applications 
>> device drivers using Java (minus the extreme hardware arch specific 
>> stuff, but supports all the low level protocol specific stuff like 
>> TCP/IP, NFS, USB etc) then I think it has potential to compete against C 

Java? Compete against C? Don't scare embedded devs.
