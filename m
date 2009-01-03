Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbZACOYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbZACOYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 09:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZACOYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 09:24:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:10666 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZACOYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 09:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RaUWvDSHBOV9MhDPhISNrOkjMjnu2aiYjedXjMnNEg67ro4iIeEKn7HCjYaIBlxX/q
         rMi87M3XVpxejx3WDDjndHHX7CBe7zLrmtkhYXavbhUbFkvZcC6F7u7Ml72lnVjVCcPZ
         WCDJKYU3NWgHDOh0oAFrrmqiunvSLPoY8DGjM=
Message-ID: <3f9a31f40901030624w4501e6f2l19d54a1e5223252c@mail.gmail.com>
Date: Sat, 3 Jan 2009 19:54:34 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: scripts/checkpatch.pl in 2.4 git
Cc: davej@redhat.com, jschopp@austin.ibm.com, apw@uk.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090103134558.GA21058@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40901030534v268d315ep4f1241042fafc456@mail.gmail.com>
	 <20090103134558.GA21058@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 3, 2009 at 7:15 PM, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Jan 03, 2009 at 07:04:57PM +0530, Jaswinder Singh Rajput wrote:
>> Hello Willy,
>>
>> Do you have any plans to add scripts/checkpatch.pl in 2.4 git.
>
> Not particularly planned, though I have nothing against including it if
> some people want to use it.
>

Please add it. At least I can use it :-)

>> Currently, what is the procedure to check patch for 2.4 git.
>
> Nowadays, 2.4 patches are so small that one's eyes are enough to check
> for correctness ;-)
>

I ran 2.6 checkpatch.pl on some files and found lot of style problems
like white spaces and indent.
After fixing these problems code will be more read-able.
I have plan to fix these problems on some important files. What you
think about this.

Thank you,
JSR
