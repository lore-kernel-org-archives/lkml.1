Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZCaMCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZCaMCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZCaMCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:02:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:8307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZCaMC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l5AUHNrqJP7/WPdBf/QSc8oFFO5f8k9/XfNskmSD6py7d0GhXvi3+KF8xKl3E7LK0N
         Nj/fvVvrb9u6KiWINSlDdliFiOvOHQX+B3c14z4kia1iRVWqIr3bH7A0xsvssKjvkYSh
         i6UXe6kNZzU/IkURqZbciUU36kSKZ9tg2SkLg=
MIME-Version: 1.0
In-Reply-To: <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	 <20090211075914.GC20842@skywalker>
	 <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
	 <20090212211935.GE6922@mini-me.lan>
	 <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
Date: Tue, 31 Mar 2009 14:02:26 +0200
Message-ID: <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a patch for 2.6.27.X for people not using git?


On Mon, Feb 16, 2009 at 11:35 PM, Chuck Ebbert <cebbert@redhat.com> wrote:
> On Thu, 12 Feb 2009 16:19:35 -0500
> Theodore Tso <tytso@mit.edu> wrote:
>
>>
>> I've updated the for-stable and for-stable-2.6.27 branches against the
>> latest stable releases, and I've updated the two flawed backports in
>> the for-stable-2.6.27 branch.  Could you do a quick double-check and
>> make sure the fixes are as you expect, before I send a pull request to
>> stable@kernel.org?
>
> The 2.6.27 branch looks good to me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
