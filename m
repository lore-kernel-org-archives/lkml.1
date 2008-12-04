Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbYLDPnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbYLDPnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbYLDPlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:41:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:15319 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbYLDPlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=EyjgCPFrGRobD5ZnQ0tmzkaPWt4nPcv+RBQWy+wfN9D0UE0Ucxk0VIRGkDiV+9alCl
         b1WhEmeS4RgyMdvVhazPTJWW3sQRHKh9tBO80J9zk2W2ocar/+gOp13B7TFTTSOqiQBz
         eJiyjyjp3e6XKsSQOw56qv15wQrBq1AO4jX5U=
Message-ID: <cfd18e0f0812040741p1d062f93t3e3b4db52d77ef34@mail.gmail.com>
Date: Thu, 4 Dec 2008 10:41:14 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Could you write some CLONE_NEWUSER?
Cc: ebiederm@xmission.com, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org, clg@fr.ibm.com, herbert@13thfloor.at,
       dev@sw.ru, "Subrata Modak" <subrata@linux.vnet.ibm.com>
In-Reply-To: <20081204153423.GA9233@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0812040720y5cabd2aarbf3912644dea42c4@mail.gmail.com>
	 <20081204153423.GA9233@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 10:34 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
>> Hi Serge,
>>
>> Thanks for CCing me on recent CLONE_NEWUSER patches.
>>
>> Would you be will to write some documentation for this flag?  (It's
>> the only remaining undocumented flag in clone(2).)  Plain text would
>> be fine -- I'll integrate it into the man page with suitable macros.
>
> Will do, will aim to send it to you by tomorrow.

Thanks Serge.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
