Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYAGSEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYAGSEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 13:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbYAGSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 13:04:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYAGSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 13:04:12 -0500
Message-ID: <4782684F.3090802@zytor.com>
Date: Mon, 07 Jan 2008 09:58:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: vgoyal@redhat.com, hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Subject: Re: kexec refuses to boot latest -mm
References: <20071228124532.GB32643@linux.vnet.ibm.com> <478264CA.5090300@zytor.com> <20080107175303.GA9319@linux.vnet.ibm.com>
In-Reply-To: <20080107175303.GA9319@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
>>
>> Could you give more details of your setup?  I'm trying to figure out 
>> exactly what it is in kexec that goes goofy, but there seems to be an 
>> enormous number of codepaths, all different, depending on things like which 
>> kind of kernel.  The more closely I can replicate your failure, the quicker 
>> I should be able to locate the problem.
>>
> 
> 
> (Anything else you need, please let me know!)

- Is your pre- and post-kexec kernels the same kernel?
- What format are you using for the post-kexec kernel?
- Exact kexec command line?
- Exact boot configuration for the pre-kexec kernel?

If you can send me the images that would be extra helpful.

Thanks!

	-hpa
