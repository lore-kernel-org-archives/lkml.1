Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZIPEY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZIPEY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZIPEYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:24:54 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:51114 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZIPEYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H3CVX1wEhp8FYYsFCMQWb1lrkTDGpVh31BHWmqsTDe4+zQnfvrrZKW/alBYN8Uqwco
         FfbRhu4cS4RjhQ2mUT4EKYSOLw0hcvZkJFvrv70pi5mU1qDC6K6tLrOITVobNnY7ReMl
         s/rnA5zRQmOJkzS4h6HHKp3eZUZHcwsFpV44Y=
MIME-Version: 1.0
In-Reply-To: <20090915211810.d1b83015.akpm@linux-foundation.org>
References: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com> 
	<20090915211810.d1b83015.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 00:24:37 -0400
Message-ID: <8bd0f97a0909152124n186278feja97a7257548b3eb7@mail.gmail.com>
Subject: Re: 2.6.32 -mm Blackfin patches
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 00:18, Andrew Morton wrote:
> On Tue, 15 Sep 2009 23:56:21 -0400 Mike Frysinger wrote:
>> On Tue, Sep 15, 2009 at 19:15, Andrew Morton wrote:
>> > blackfin-fix-read-buffer-overflow.patch
>>
>> the latter patch i merged into my tree (and i thought that i followed
>> up in the original posting about this)
>
> Well, it isn't in linux-next so as far as I'm concerned I have the
> only copy.  Should you be getting your tree into linux-next?

not sure how the next process works.  what do i need to do Stephen ?
-mike
