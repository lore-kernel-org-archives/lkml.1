Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbYJQJOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbYJQJOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYJQJOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:14:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:37613 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYJQJON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uf1HrCidZcJ8ZwwRNGutxVVtsyr9ERReCyV0lIZrfKql5684SEv3GatWFMZhVQXl+4
         L6mAq110cRoJoAwT5iY73S3uHwhIkVHnXYUkPgRzqNy+8DnrbNVW2n6wsTAhwRk8ukW2
         4q5QV7HDiweoG2rp5SccvJA99vYIA586YHutU=
Message-ID: <a8e1da0810170214m1db20450m3e1df9cf621a56b4@mail.gmail.com>
Date: Fri, 17 Oct 2008 17:14:12 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jike Song" <albcamus@gmail.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Cc: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <df9815e70810170205s4f25914dy7e24a081447d285d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081016002509.GA25868@kroah.com>
	 <20081016142619.GA3756@tatooine.rebelbase.local>
	 <20081016153512.GE12962@mit.edu>
	 <a8e1da0810161853m3bbd8c1hf7c2ed5adf4cc4d6@mail.gmail.com>
	 <df9815e70810170205s4f25914dy7e24a081447d285d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 5:05 PM, Jike Song <albcamus@gmail.com> wrote:
> On Fri, Oct 17, 2008 at 9:53 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>>
>> Additionally, we can add some range to x.y.z
>>
>> such as:
>>
>> x: 1-9
>> y: 1-9
>> z: 1-30
>>
>> so we can jumo to 2.7.1 after 2.6.30
>>
>
> Then people will think 2.7.x is a development version like 2.5.x ...

But it isn't. I think it doesn't matter.

There's no such development version now. It's just a chance to let
every one know the old change.

-- 
Regards
dave
