Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYLHL7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYLHL7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYLHL5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:57:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49057 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbYLHL5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:57:19 -0500
Message-ID: <493D0B9A.9000401@redhat.com>
Date: Mon, 08 Dec 2008 13:57:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
References: <200812021114.59050.borntraeger@de.ibm.com> <200812081251.14648.borntraeger@de.ibm.com>
In-Reply-To: <200812081251.14648.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Dienstag, 2. Dezember 2008 schrieb Christian Borntraeger:
>   
>> Hello Avi,
>>
>> here is the latest respin of my fixes for the kvm module unload problem:
>>
>> [PATCH 1/2] anon_inodes: use fops->owner for module refcount
>> [PATCH 2/2] kvm: set owner of cpu and vm file operations
>>     
>
> In the meantime patch 2 has a offset against the latest git. Should I resend
> the patch or will you apply it anyway?
>   

Applied the patches; thanks for the reminder.

-- 
error compiling committee.c: too many arguments to function

