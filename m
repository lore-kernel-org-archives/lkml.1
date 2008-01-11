Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbYAKJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbYAKJlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbYAKJlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:41:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:49222 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbYAKJlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MLnVBdw6he3VQTUHYCOONEYtoTq+xv13O/NbPgQmueRIl1xIXJceytfXzXvrpr/iKllNcjlOqs0n2wUB8YXLbHJF5gmVcCj6jeRawdamWjNG4saN+foFRLad94bP/fVyNXtCVuZS2wrF4hBO4DeIv34GlCspwLKb++T74sx/gx8=
Message-ID: <478739AD.3000005@gmail.com>
Date: Fri, 11 Jan 2008 10:41:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Bernd Petrovitsch <bernd@firmix.at>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch.pl: allow piping
References: <20080111041120.085610726@mvista.com>	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com> <1200044206.29897.73.camel@imap.mvista.com>
In-Reply-To: <1200044206.29897.73.camel@imap.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 10:36 AM, Daniel Walker wrote:
> On Fri, 2008-01-11 at 10:34 +0100, Jiri Slaby wrote:
>> If somebody is hacking kernel, I think he should know the - trick used in many 
>> programs, but do not consider this as a nack.
> 
> I'm hacking the kernel, and I didn't know the - trick .. So you have
> your testing case all in one with the patch submitter ..

OK, maybe we should base it in doc for patch submitting then?

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
