Return-Path: <linux-kernel-owner+w=401wt.eu-S1764658AbYD3VKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764658AbYD3VKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbYD3VJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:09:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31045 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbYD3VJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=P0j2ViKJew2l7K/tmN8zs7dk6hF8QH9vDa79+vqZad9tOWjn3412e8h0IuqD9edHHNbiCgQPmV03KUihlhStPE7x3T3FkZ40d2DuT1YepzI7MJIZCJeriZDPHeYvRt2qfK3kGqEMwfoMp5QaarCllJZAyEgE0IScq6M3b594lYg=
Message-ID: <4818DE7D.9050900@bellsouth.net>
Date: Wed, 30 Apr 2008 16:02:53 -0500
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: jacliburn@bellsouth.net
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
       pavel@suse.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to
 ram
References: <4818D9AB.3040402@googlemail.com> <4818DA98.4040001@bellsouth.net>
In-Reply-To: <4818DA98.4040001@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Jay Cliburn <jcliburn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> Gabriel C wrote:
>> Hi all,
>>
>> I thought I've found all issue with that new box but I was wrong ;)
>>
>> On an ASUS P5E-VM DO , 4G RAM , Q9300 CPU after suspend to ram Thermal 
>> Subsystem gets corrupted in some way.
> 
> Does this board contain an Attansic L1 NIC?

Belay that.  I see it's an Intel NIC.

http://www.asus.com/products.aspx?modelmenu=2&model=1849&l1=3&l2=11&l3=571&l4=0

I should've looked first.  Sorry for the noise.
