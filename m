Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYBJKft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYBJKft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYBJKfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:35:41 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:46975
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbYBJKfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:35:40 -0500
Message-ID: <47AED37B.90406@qumranet.com>
Date: Sun, 10 Feb 2008 12:35:39 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in
 AMD Fam16 CPUs
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <479C4763.1080104@qumranet.com> <20080207120909.GE6960@amd.com>
In-Reply-To: <20080207120909.GE6960@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Sun, Jan 27, 2008 at 10:57:07AM +0200, Avi Kivity wrote:
>   
>> Very nice patchset; small, simple, and clean.  Apart from the comments
>> I already posted, I'd like to avoid the term 'hap': I find it
>> non-descriptive, and it reminds me of another hypervisor.  I suggest
>> 'tlp' for two-level paging.
>>     
>
> I renamed HAP to TDP. This stands for Two-Dimensional Paging and is the
> term which descibes best what happens in my opinion.
>
>   

Yes, it actually describes what is going on in there.

-- 
error compiling committee.c: too many arguments to function

