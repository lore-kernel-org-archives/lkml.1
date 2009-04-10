Return-Path: <linux-kernel-owner+w=401wt.eu-S935870AbZDJQbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935870AbZDJQbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760164AbZDJQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:30:54 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:43563 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720AbZDJQax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=b0dl0YGiMnAdtKNsP58o696/DkLy2QiGEwYwEepqfoyeHSNk1/4riDug9yIh7QGw2D
         RwTaHTY8lIURIPWKfRYLDGm5MhowjjiQ70YYQcJ/UqVQh1h4kfN1ANvB72r0tgpLBEfD
         rr1F0qQV+RDfXX84apvoEEDJ3LhUQIUveeXbk=
MIME-Version: 1.0
In-Reply-To: <3d2f29dc0904081505l4e0203a0q25144d200164c82a@mail.gmail.com>
References: <3d2f29dc0904071551xadea34ajd2c177380ced4fef@mail.gmail.com>
	 <49DCDF1F.5050805@xandros.com>
	 <3d2f29dc0904081505l4e0203a0q25144d200164c82a@mail.gmail.com>
Date: Fri, 10 Apr 2009 12:30:51 -0400
Message-ID: <3d2f29dc0904100930n7f1216cdm1b48657a0d01e97f@mail.gmail.com>
Subject: Re: Weird freezes with 2.6.28/29
From: Chris Howie <cdhowie@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 6:05 PM, Chris Howie <cdhowie@gmail.com> wrote:
> On Wed, Apr 8, 2009 at 1:30 PM, Woody Suwalski <woodys@xandros.com> wrote:
>> I am getting similar problem on Dell 4x00 laptops caused by loading
>> processor.ko.
>> If I use nocst=1 option, systems are OK.
>
> Thanks, this has eliminated the second freeze (where I must hold down
> a key to allow boot to proceed) but I still have to hit the power
> button to get the initial boot going.
>
> Getting closer!

Also anyone replying please note that I am no longer subscribed.
Please CC me on replies.

-- 
Chris Howie
http://www.chrishowie.com
http://en.wikipedia.org/wiki/User:Crazycomputers
