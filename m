Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZJLJ4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZJLJ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZJLJ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:56:13 -0400
Received: from mx10.lb01.inode.at ([62.99.145.10]:14841 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755028AbZJLJ4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:56:12 -0400
Message-ID: <4AD2FD10.2010800@sbg.ac.at>
Date: Mon, 12 Oct 2009 11:55:28 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       alexander.huemer@sbg.ac.at
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200910101513.51320.elendil@planet.nl> <4AD2DFA4.9000602@kernel.org> <200910121148.16439.elendil@planet.nl> <4AD2FC60.8080705@kernel.org>
In-Reply-To: <4AD2FC60.8080705@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Frans Pop wrote:
>   
>> On Monday 12 October 2009, Tejun Heo wrote:
>>     
>>> Alexander, can you please attach full boot log and the output of
>>> "lspci -nn"?  Also, how reproducible is the problem?  You already
>>> answered to Frans' question but can you be more specific?
>>>       
>> Full dmesg was made available earlier at:
>> http://xx.vu/~ahuemer/dmesg_ahuemer_20090923
>>     
>
> Does blacklisting i801_smbus make any difference?
>
>   
lspci -nn:
http://xx.vu/~ahuemer/lspci_nn_ahuemer_20091012

what do you mean with "blacklisting i801_smbus" ?

regards
-alex
