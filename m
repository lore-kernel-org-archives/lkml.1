Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZASTbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZASTbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZASTbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:31:42 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:2816 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZASTbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IiWbZs9YQSybBEydkB6ssMedC4n0V85P0CISWqE5N8iJgMbqKD+68ChcNFpvBgcq9h
         1eVw0oN1LTHRWIbxWjXvwQFl0nr3voBUxoCgy6O7SDlvhjo067w1wzu5eWEHotgaHYPW
         qB+4b8/kc1F8f2OiKL/ZN2lAGSe/iufAHsrU8=
MIME-Version: 1.0
In-Reply-To: <4974CC8B.1030403@zytor.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
	 <4974CC8B.1030403@zytor.com>
Date: Mon, 19 Jan 2009 11:31:40 -0800
Message-ID: <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due 
	to dc1e35c
From: Avuton Olrich <avuton@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 H. Peter Anvin <hpa@zytor.com>:
>>
>> bisected to:
>> commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
>> Author: Suresh Siddha <suresh.b.siddha@intel.com>
>> Date:   Tue Jul 29 10:29:19 2008 -0700
>>
>
> Avuton, could you please compile the attached program and send us the
> output?

Sure whichever flavor you prefer:
http://avuton.googlepages.com/cpuid-out (3M)
http://avuton.googlepages.com/cpuid-out.bz2 (40K)
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
