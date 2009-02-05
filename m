Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZBEQW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZBEQW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZBEQWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:22:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:35036 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZBEQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RESBKPUbzJbECuKuG/mOkh0/b+Ihb4lbOQgbzwE6AobLK3E5WYJO5SCUUJuu2CHHS/
         AZhj3JtIzw9N7wWQ8TKSQbdcuF89fEnjRAxbiA6ev6DdeDj8qi21TQ8ZWU79KzeV+jp6
         ksfe7OdWRAbq3xEWqzicvSQc1RRmR19L0nUa0=
MIME-Version: 1.0
In-Reply-To: <20090205155854.GG6915@linux.vnet.ibm.com>
References: <20090130200757.GA14999@Krystal>
	 <20090205140432.GE6915@linux.vnet.ibm.com>
	 <20090205150242.GA27895@Krystal>
	 <20090205151841.GF6915@linux.vnet.ibm.com>
	 <20090205153825.GA30255@Krystal>
	 <20090205155854.GG6915@linux.vnet.ibm.com>
Date: Thu, 5 Feb 2009 21:52:16 +0530
Message-ID: <5d5443650902050822r2e4d08ffg2322b45a5e009fb8@mail.gmail.com>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
From: Trilok Soni <soni.trilok@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> Are you using quilt to apply the patchset series file in the right order ?
>
> Ummm...  No.  I never have used quilt.
>
> Ah, there is a series file.  I guess it would not be too hard to make
> an appropriate "sh" command:
>

How about trying?


#quilt push -a

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
